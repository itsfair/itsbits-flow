import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:itsbits_dart/door_code.dart' as door_code;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../site/global_site_connection.dart';

const Duration _kEspTimeout = Duration(seconds: 5);

/// Admin endpoint for the site's doorinterface devices (ESP32) — the LAN
/// registry of `Selbsteinlass`: add devices by address (IP or local
/// hostname), test the connection via the ESP's `/api/status`, and
/// trigger the NUKI lock/unlock/open actions. The HTTP calls to the ESP
/// happen on the SERVER side (LAN authority stays with the instance,
/// avoids browser CORS).
///
/// MVP security stance: plain HTTP into the local network (the ESP's web
/// interface as unauthenticated as its dashboard); device
/// authentication/TLS is a known security backlog item. The NUKI unlock/
/// lock/open routes are fixed backend-side paths — no generic proxying.
///
/// Access is enforced declaratively via [requiredScopes] (`local-admin`
/// scope of the site admin's local login), same as membersAdmin/siteAdmin.
class DoorDeviceAdminEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {const Scope(kLocalAdminScope)};

  /// All registered devices, newest first.
  Future<List<DoorDevice>> listDevices(final Session session) async {
    return DoorDevice.db.find(
      session,
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
  }

  /// Registers a new device ("Gerät hinzufügen") and IMMEDIATELY pushes
  /// the backend config (serverUrl + siteId) to it — best effort: a
  /// failed push never blocks the registration (re-push via
  /// [pushConfig] later).
  Future<DoorDevice> addDevice(
    final Session session, {
    required final String name,
    required final String address,
  }) async {
    final normalizedAddress = _normalizeAddress(address);
    await _ensureAddressFree(session, normalizedAddress, excludeId: null);
    final row = await DoorDevice.db.insertRow(
      session,
      DoorDevice(name: _validateName(name), address: normalizedAddress),
    );
    try {
      await pushConfig(session, id: row.id!);
    } catch (_) {}
    return row;
  }

  /// Updates the display name and/or the address.
  Future<DoorDevice> updateDevice(
    final Session session, {
    required final int id,
    final String? name,
    final String? address,
  }) async {
    final row = await _requireDevice(session, id);
    if (name == null && address == null) return row;

    var updated = row;
    if (name != null) {
      updated = updated.copyWith(name: _validateName(name));
    }

    if (address != null) {
      final normalizedAddress = _normalizeAddress(address);
      if (normalizedAddress != row.address) {
        await _ensureAddressFree(session, normalizedAddress, excludeId: row.id);
      }
      updated = updated.copyWith(address: normalizedAddress);
    }

    return DoorDevice.db.updateRow(session, updated);
  }

  /// Removes the registry entry (the ESP itself is untouched).
  Future<void> removeDevice(
    final Session session, {
    required final int id,
  }) async {
    final row = await _requireDevice(session, id);
    await DoorDevice.db.deleteRow(session, row);
  }

  /// Probes `GET http://<address>/api/status` and parses the ESP JSON
  /// losslessly (server-side call, timeout 5 s).
  Future<DoorDeviceStatus> testDevice(
    final Session session, {
    required final int id,
  }) async {
    final row = await _requireDevice(session, id);
    final result = await _call(row.address, '/api/status', post: false);
    return switch (result) {
      _EspSuccess() => _parseStatus(result),
      _ => DoorDeviceStatus(ok: false, error: _callError(result)),
    };
  }

  /// `POST /api/nuki/unlock` on the device (NUKI entriegeln).
  Future<DoorDeviceStatus> unlockNuki(
    final Session session, {
    required final int id,
  }) async {
    final row = await _requireDevice(session, id);
    return _nukiAction(row.address, 'unlock');
  }

  /// `POST /api/nuki/lock` on the device (NUKI verriegeln).
  Future<DoorDeviceStatus> lockNuki(
    final Session session, {
    required final int id,
  }) async {
    final row = await _requireDevice(session, id);
    return _nukiAction(row.address, 'lock');
  }

  /// `POST /api/nuki/open` on the device (NUKI entsichern / unlatch).
  Future<DoorDeviceStatus> openNuki(
    final Session session, {
    required final int id,
  }) async {
    final row = await _requireDevice(session, id);
    return _nukiAction(row.address, 'open');
  }

  /// Pushes the backend config (server URL from the `localApiUrl`
  /// password key + this instance's site ID) to the device
  /// (`POST http://<address>/api/backend/config`). The device ACKs with
  /// its identity; the MAC is stored on the registry row and
  /// `configuredAt` marks a successful push.
  Future<DoorDevicePushResult> pushConfig(
    final Session session, {
    required final int id,
  }) async {
    final row = await _requireDevice(session, id);

    final serverUrl = Serverpod.instance.getPassword('localApiUrl');
    if (serverUrl == null || serverUrl.isEmpty) {
      throw DoorDeviceException(
        message:
            'localApiUrl fehlt in config/passwords.yaml der lokalen '
            'Instanz (oder als SERVERPOD_PASSWORD_localApiUrl).',
      );
    }
    final connection = await SiteConnection.db.findFirstRow(session);
    if (connection == null) {
      throw DoorDeviceException(
        message: 'Diese Instanz ist nicht eingerichtet.',
      );
    }

    final result = await _postForm(
      address: row.address,
      path: '/api/backend/config',
      fields: {'url': serverUrl, 'siteId': '${connection.siteId}'},
    );

    if (result is! _EspSuccess) {
      return DoorDevicePushResult(ok: false, error: _callError(result));
    }
    if (result.status != 200) {
      return DoorDevicePushResult(
        ok: false,
        error:
            'Gerät antwortete mit HTTP ${result.status}'
            '${result.body.trim().isEmpty ? '' : ': ${result.body.trim()}'}',
      );
    }

    String? mac;
    String? hostname;
    try {
      final json = jsonDecode(result.body);
      if (json is Map<String, dynamic>) {
        // Store the MAC in canonical form (the verifier resolves the
        // policy device by it).
        mac = json['mac'] is String
            ? door_code.normalizeDeviceMac(json['mac'] as String)
            : null;
        hostname = json['hostname'] is String
            ? json['hostname'] as String
            : null;
      }
    } catch (_) {}

    await DoorDevice.db.updateRow(
      session,
      row.copyWith(mac: mac, configuredAt: DateTime.now()),
    );
    return DoorDevicePushResult(ok: true, mac: mac, hostname: hostname);
  }

  // -- Private helpers

  String _validateName(final String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw DoorDeviceException(message: 'Der Name darf nicht leer sein.');
    }
    return trimmed;
  }

  Future<void> _ensureAddressFree(
    final Session session,
    final String address, {
    required final int? excludeId,
  }) async {
    final duplicate = await DoorDevice.db.findFirstRow(
      session,
      where: (t) => t.address.equals(address),
    );
    if (duplicate != null && duplicate.id != excludeId) {
      throw DoorDeviceException(
        message:
            'Unter dieser Adresse ist bereits das Gerät '
            '"${duplicate.name}" eingetragen.',
      );
    }
  }

  Future<DoorDevice> _requireDevice(final Session session, final int id) async {
    final row = await DoorDevice.db.findById(session, id);
    if (row == null) {
      throw DoorDeviceException(message: 'Gerät wurde nicht gefunden.');
    }
    return row;
  }

  Future<DoorDeviceStatus> _nukiAction(
    final String address,
    final String action,
  ) async {
    final result = await _call(address, '/api/nuki/$action', post: true);
    return switch (result) {
      _EspSuccess(:final status) when status == 200 => DoorDeviceStatus(
        ok: true,
      ),
      _EspSuccess(:final status, :final body) => DoorDeviceStatus(
        ok: false,
        error: _actionError(status, body),
      ),
      _ => DoorDeviceStatus(ok: false, error: _callError(result)),
    };
  }

  DoorDeviceStatus _parseStatus(final _EspSuccess response) {
    if (response.status != 200) {
      return DoorDeviceStatus(
        ok: false,
        error: 'ESP antwortete mit HTTP ${response.status}.',
      );
    }
    dynamic json;
    try {
      json = jsonDecode(response.body);
    } catch (_) {
      return DoorDeviceStatus(
        ok: false,
        error: 'Antwort ist kein gültiges JSON.',
      );
    }
    if (json is! Map<String, dynamic>) {
      return DoorDeviceStatus(
        ok: false,
        error: 'Unerwartetes Antwortformat.',
      );
    }
    final wifi = _asMap(json['wifi']);
    final locks = _asMap(json['locks']);
    final firmware = _asMap(json['firmware']);
    return DoorDeviceStatus(
      ok: true,
      wifiSsid: _asString(wifi?['ssid']),
      wifiRssi: _asInt(wifi?['rssi']),
      wifiIp: _asString(wifi?['ip']),
      locksAvailable: _asBool(locks?['available']),
      locksPaired: _asBool(locks?['paired']),
      locksPairing: _asBool(locks?['pairing']),
      locksCount: _asInt(locks?['count']),
      locksLockState: _asString(locks?['lockState']),
      locksBatteryPct: _asInt(locks?['batteryPct']),
      locksBatteryCritical: _asBool(locks?['batteryCritical']),
      locksRssi: _asInt(locks?['rssi']),
      firmwareVersion: _asString(firmware?['version']),
    );
  }

  String _actionError(final int statusCode, final String body) {
    if (statusCode == 409) {
      return 'ESP erreichbar, aber es ist kein NUKI-Schloss gepaired.';
    }
    if (body.contains('"ok":false')) {
      return 'ESP erreichbar, aber der NUKI-Befehl ist fehlgeschlagen.';
    }
    return 'ESP antwortete mit HTTP $statusCode.';
  }

  String _callError(final _EspResult result) {
    final reason = switch (result) {
      _EspNetworkError(:final message) => message,
      _EspTimeout() => 'keine Antwort (Timeout nach 5 s)',
      _ => 'unbekannter Fehler',
    };
    return 'ESP nicht erreichbar ($reason). '
        'Prüfe Adresse und Netzwerkverbindung.';
  }

  /// Performs one HTTP call against the device. GET for status queries,
  /// POST for the NUKI actions; the address is taken verbatim (it was
  /// normalized at registration — `host[:port]`, no path).
  Future<_EspResult> _call(
    final String address,
    final String path, {
    required final bool post,
  }) async {
    final uri = Uri.http(address, path);
    final client = HttpClient();
    try {
      client.connectionTimeout = _kEspTimeout;
      final request = post
          ? await client.postUrl(uri)
          : await client.getUrl(uri);
      final response = await request.close().timeout(_kEspTimeout);
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(_kEspTimeout);
      return _EspSuccess(status: response.statusCode, body: body);
    } on TimeoutException {
      return const _EspTimeout();
    } on SocketException catch (e) {
      return _EspNetworkError(e.message);
    } on HttpException catch (e) {
      return _EspNetworkError(e.message);
    } catch (e) {
      return _EspNetworkError('$e');
    } finally {
      client.close(force: true);
    }
  }

  /// POST with form-urlencoded fields (same encoding the ESP setup page
  /// uses) — e.g. the backend config push.
  Future<_EspResult> _postForm({
    required final String address,
    required final String path,
    required final Map<String, String> fields,
  }) async {
    final uri = Uri.http(address, path);
    final payload = utf8.encode(
      fields.entries
          .map(
            (entry) =>
                '${Uri.encodeQueryComponent(entry.key)}='
                '${Uri.encodeQueryComponent(entry.value)}',
          )
          .join('&'),
    );
    final client = HttpClient();
    try {
      client.connectionTimeout = _kEspTimeout;
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
      );
      // REQUIRED: the Arduino WebServer on the ESP parses the body by
      // Content-Length — without this header Dart sends the body
      // chunked and the ESP sees empty args (HTTP 400).
      request.contentLength = payload.length;
      request.add(payload);
      final response = await request.close().timeout(_kEspTimeout);
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(_kEspTimeout);
      return _EspSuccess(status: response.statusCode, body: body);
    } on TimeoutException {
      return const _EspTimeout();
    } on SocketException catch (e) {
      return _EspNetworkError(e.message);
    } on HttpException catch (e) {
      return _EspNetworkError(e.message);
    } catch (e) {
      return _EspNetworkError('$e');
    } finally {
      client.close(force: true);
    }
  }

  Map<String, dynamic>? _asMap(final dynamic value) =>
      value is Map<String, dynamic> ? value : null;

  String? _asString(final dynamic value) => value is String ? value : null;

  int? _asInt(final dynamic value) => value is int ? value : null;

  bool? _asBool(final dynamic value) => value is bool ? value : null;

  /// Normalizes the entered address to `host[:port]` — scheme prefixes
  /// (`http://`, `https://`) are accepted and stripped, trailing slashes
  /// are ignored, paths are rejected. Lowercased (DNS names are
  /// case-insensitive) so the unique check is stable.
  String _normalizeAddress(final String raw) {
    var value = raw.trim().toLowerCase();
    if (value.startsWith('http://')) {
      value = value.substring(7);
    } else if (value.startsWith('https://')) {
      value = value.substring(8);
    }
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    if (value.isEmpty || value.contains('/') || value.contains(' ')) {
      throw DoorDeviceException(
        message:
            'Ungültige Adresse — IP oder hostname(.local), optional '
            'mit :port angeben.',
      );
    }
    return value;
  }
}

/// One attempt of talking to the device (sealed for the switch above).
sealed class _EspResult {
  const _EspResult();
}

class _EspSuccess extends _EspResult {
  final int status;
  final String body;

  const _EspSuccess({required this.status, required this.body});
}

class _EspTimeout extends _EspResult {
  const _EspTimeout();
}

class _EspNetworkError extends _EspResult {
  final String message;

  const _EspNetworkError(this.message);
}
