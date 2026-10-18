import 'package:flutter/material.dart';

import '../door_device_directory.dart';

/// Status card for one doorinterface (ESP32): connection test at the top
/// (refreshable), Wi-Fi and lock status blocks (only rendered when the
/// probe succeeded / the field is present).
class DoorDeviceStatusCard extends StatelessWidget {
  final DoorDeviceStatusData? status;
  final bool testing;
  final VoidCallback onTest;

  const DoorDeviceStatusCard({
    required this.status,
    required this.testing,
    required this.onTest,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final s = status;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Verbindung', style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  tooltip: 'Testen',
                  onPressed: testing ? null : onTest,
                  icon: testing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.wifi_tethering),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (testing && s == null)
              const Text('Teste Verbindung …')
            else if (s == null)
              const Text('Noch nicht getestet — Verbindungstest starten.')
            else if (!s.ok)
              Text(
                s.error ?? 'Gerät nicht erreichbar.',
                style: TextStyle(color: theme.colorScheme.error),
              )
            else ...[
              _okChip(theme),
              const SizedBox(height: 8),
              if (s.wifiIp case final ip?) _line('ESP-IP', ip),
              if (s.wifiSsid case final ssid?) _line('WLAN', ssid),
              if (s.wifiRssi case final rssi?)
                _line('WLAN-Signal', '$rssi dBm'),
              const SizedBox(height: 8),
              _lockBlock(theme, s),
              if (s.firmwareVersion case final version?)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _line('Firmware', version),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _okChip(final ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        avatar: const Icon(Icons.check_circle, size: 16, color: Colors.green),
        label: const Text('ESP erreichbar'),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _lockBlock(final ThemeData theme, final DoorDeviceStatusData s) {
    if (s.locksAvailable != true) {
      return const Text(
        'Schloss-Steuerung am ESP nicht verfügbar.',
        style: TextStyle(color: Colors.blueGrey),
      );
    }
    if (s.locksPairing == true) {
      return const Text('Gerät koppelt gerade mit einem Schloss …');
    }
    if (s.locksPaired != true) {
      return const Text(
        'Kein NUKI-Schloss gepaired (am Gerät koppeln).',
        style: TextStyle(color: Colors.blueGrey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line('Zustand', s.locksLockState ?? '—'),
        if (s.locksBatteryPct case final pct?)
          _line(
            'Batterie',
            '$pct%${s.locksBatteryCritical == true ? ' (kritisch)' : ''}',
          ),
        if (s.locksRssi case final rssi?) _line('Schloss-Signal', '$rssi dBm'),
      ],
    );
  }

  Widget _line(final String label, final String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
