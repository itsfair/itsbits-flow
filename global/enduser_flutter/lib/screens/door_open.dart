import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:global_client/global_client.dart' show SiteAdminException;
import 'package:serverpod_client/serverpod_client.dart'
    show ServerpodClientException;

import '../ble/ble_constants.dart';
import '../ble/door_open_session.dart';
import '../client.dart';
import '../door_secret_store.dart';

/// Self-entry flow: runs automatically after scanning a doorinterface QR.
/// Fetches (once per site, cached) the door secret from the global
/// instance, computes the rolling code offline and sends it over BLE to
/// the device, which verifies via the local instance and unlatches.
class DoorOpenScreen extends StatefulWidget {
  final ParsedQr parsed;

  const DoorOpenScreen({required this.parsed, super.key});

  @override
  State<DoorOpenScreen> createState() => _DoorOpenScreenState();
}

class _DoorOpenScreenState extends State<DoorOpenScreen> {
  final DoorOpenSession _session = DoorOpenSession();

  DoorOpenPhase _phase = DoorOpenPhase.preparing;
  String? _message;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() {
      _phase = DoorOpenPhase.preparing;
      _message = null;
      _success = false;
    });

    final userKey = profileState.profile?.authUserId;
    if (userKey == null || userKey.isEmpty) {
      setState(() {
        _phase = DoorOpenPhase.error;
        _message = 'Profil nicht geladen — bitte neu anmelden.';
      });
      return;
    }

    final siteId = widget.parsed.siteId;
    if (siteId == null) {
      setState(() {
        _phase = DoorOpenPhase.error;
        _message =
            'Dieses doorinterface ist noch nicht mit einem Standort '
            'verbunden (Site-ID fehlt im QR-Code).';
      });
      return;
    }

    final secret = await _loadSecret(siteId);
    if (secret == null || !mounted) return;

    var result = await _openDoor(siteId, userKey, secret);
    if (result == null || !mounted) return;
    if (!result.success && result.responseCode == 'ACCESS_DENIED') {
      // Self-healing: a rotated secret (membership reactivation
      // generates a new one) invalidates the cached copy — drop it,
      // re-fetch and retry exactly once. Nothing was consumed on a
      // denial, so the retry is free.
      await doorSecretStore.forgetSite(siteId);
      if (!mounted) return;
      setState(() {
        _phase = DoorOpenPhase.preparing;
        _message = 'Zugangsdaten wurden erneuert — zweiter Versuch …';
      });
      final fresh = await _loadSecret(siteId);
      if (fresh == null || !mounted) return;
      result = await _openDoor(siteId, userKey, fresh);
    }

    if (result == null || !mounted) return;
    final outcome = result;
    setState(() {
      _phase = outcome.finalPhase;
      _success = outcome.success;
      _message = outcome.success
          ? (outcome.responseMessage ?? 'Tür öffnet sich …')
          : _mapResponse(outcome);
    });
  }

  Future<String?> _loadSecret(final int siteId) async {
    try {
      return await doorSecretStore.secretForSite(siteId);
    } on Exception catch (e) {
      if (!mounted) return null;
      setState(() {
        _phase = DoorOpenPhase.error;
        _message =
            'Zugangsdaten konnten nicht geladen werden: ${_errorText(e)} '
            '(Internetverbindung nötig, wenn der Code zum ersten Mal auf '
            'diesem Gerät genutzt wird.)';
      });
      return null;
    }
  }

  Future<DoorOpenResult?> _openDoor(
    final int siteId,
    final String userKey,
    final String secret,
  ) async {
    if (!mounted) return null;
    setState(() {
      _phase = DoorOpenPhase.connecting;
      _message = 'Verbinde mit dem Türgerät …';
    });
    return _session.run(
      remoteId: widget.parsed.remoteId,
      siteId: siteId,
      userKey: userKey,
      secretHex: secret,
    );
  }

  String _errorText(final Exception e) {
    if (e is SiteAdminException) {
      return e.message;
    }
    if (e is ServerpodClientException) {
      return '$e';
    }
    return '$e';
  }

  String _mapResponse(final DoorOpenResult result) {
    final detail = result.responseMessage;
    final fallback = result.errorMessage ?? 'Unbekannter Fehler.';
    return switch (result.responseCode) {
      'DEVICE_UNCONFIGURED' =>
        'Dieses doorinterface ist noch nicht mit dem Standort verbunden.',
      'NOT_PAIRED' => 'Am Türgerät ist kein Schloss gekoppelt.',
      'CRED_INVALID' => 'Zugangsdaten unvollständig — bitte Scan wiederholen.',
      'ACCESS_DENIED' =>
        'Zugang verweigert${detail == null ? '' : ': $detail'}.',
      'RATE_LIMITED' =>
        'Zu viele Versuche — bitte kurz warten und erneut versuchen.',
      'BACKEND_UNREACHABLE' =>
        'Die Standort-Instanz ist gerade nicht erreichbar.',
      'LOCK_FAILED' => 'Tür konnte nicht geöffnet werden.',
      'UNKNOWN_ACTION' => 'Das Gerät hat die Anfrage nicht verstanden.',
      null => fallback,
      _ => detail ?? fallback,
    };
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final busy =
        _phase == DoorOpenPhase.preparing || _phase == DoorOpenPhase.connecting;

    return Scaffold(
      appBar: AppBar(title: const Text('Türöffnung')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (busy) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    _phase == DoorOpenPhase.preparing
                        ? 'Bereite Zugang vor …'
                        : 'Verbinde mit dem Türgerät …',
                  ),
                ] else ...[
                  Icon(
                    _success ? Icons.check_circle : Icons.error_outline,
                    size: 56,
                    color: _success ? Colors.green : theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _success ? 'Tür öffnet sich …' : 'Fehlgeschlagen',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
                if (_message != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _message!,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                if (!busy) ...[
                  FilledButton(
                    onPressed: _run,
                    child: const Text('Erneut versuchen'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Zurück'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
