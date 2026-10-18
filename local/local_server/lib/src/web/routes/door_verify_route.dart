import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../door/door_access_verifier.dart';
import '../../generated/protocol.dart' show DoorAccessResult;

/// REST route for the doorinterfaces (plain HTTP, LAN, no device auth in
/// the MVP — security hardening is a known backlog item): the ESP posts
/// one verification request per BLE request, the response mirrors the
/// BLE contract ({ok, code, message}).
///
/// Result codes (uniform — no detail leak):
/// - `OK`            granted
/// - `ACCESS_DENIED` any credential failure (unknown/inactive/wrong/replay)
/// - `RATE_LIMITED`  too many denied attempts for this user
/// - `CRED_INVALID`  malformed request (400)
/// - `SERVER_ERROR`  infrastructure failure (500)
class DoorVerifyRoute extends Route {
  DoorVerifyRoute() : super(methods: {Method.post}, path: '/api/door/verify');

  @override
  FutureOr<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    final body = await request.readAsString();
    dynamic json;
    try {
      json = jsonDecode(body);
    } catch (_) {
      return _respond(DoorAccessResult.invalid);
    }
    if (json is! Map<String, dynamic>) {
      return _respond(DoorAccessResult.invalid);
    }

    final userKeyRaw = json['userKey'];
    final code = json['code'];
    final deviceMac = json['deviceMac'];
    final timestampMs = json['timestampMs'];
    final siteId = json['siteId'];
    if (userKeyRaw is! String ||
        code is! String ||
        deviceMac is! String ||
        timestampMs is! int ||
        siteId is! int) {
      return _respond(DoorAccessResult.invalid);
    }

    final UuidValue userKey;
    try {
      userKey = UuidValue.fromString(userKeyRaw);
    } catch (_) {
      return _respond(DoorAccessResult.invalid);
    }

    try {
      final result = await DoorAccessVerifier().verify(
        session,
        userKey: userKey,
        code: code,
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: timestampMs,
      );
      return _respond(result);
    } catch (e) {
      session.log('door verify failed: $e', level: LogLevel.error);
      return _respond(DoorAccessResult.error);
    }
  }

  Result _respond(final DoorAccessResult result) {
    final (status, code, message) = switch (result) {
      DoorAccessResult.granted => (200, 'OK', 'Zugang gewährt'),
      DoorAccessResult.denied => (200, 'ACCESS_DENIED', 'Zugang verweigert'),
      DoorAccessResult.timeSkew => (
        200,
        'TIME_SKEW',
        'Geräte-Zeit weicht ab — bitte automatische Zeiteinstellung '
            'aktivieren',
      ),
      DoorAccessResult.rateLimited => (
        200,
        'RATE_LIMITED',
        'Zu viele Versuche — bitte kurz warten',
      ),
      DoorAccessResult.invalid => (400, 'CRED_INVALID', 'Ungültige Anfrage'),
      DoorAccessResult.error => (500, 'SERVER_ERROR', 'Interner Fehler'),
    };
    final body = jsonEncode({
      'ok': result == DoorAccessResult.granted,
      'code': code,
      'message': message,
    });
    final response = switch (status) {
      400 => Response.badRequest(
        body: Body.fromString(body, mimeType: MimeType.json),
      ),
      500 => Response.internalServerError(
        body: Body.fromString(body, mimeType: MimeType.json),
      ),
      _ => Response.ok(body: Body.fromString(body, mimeType: MimeType.json)),
    };
    return response;
  }
}
