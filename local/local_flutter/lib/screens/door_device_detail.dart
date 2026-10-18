import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/door_device_directory.dart';
import 'package:itsbits_shared/widgets/door_device_dialog.dart';
import 'package:itsbits_shared/widgets/door_device_status_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../client.dart';
import '../door_device_api.dart';

/// Detail of one registered doorinterface (ESP32): connection test +
/// status, the three NUKI actions (confirmation before each), name/
/// address editing, removal, and a direct link to the device's own web
/// interface (`http://<address>`).
class DoorDeviceDetailScreen extends StatefulWidget {
  final int deviceId;

  const DoorDeviceDetailScreen({required this.deviceId, super.key});

  @override
  State<DoorDeviceDetailScreen> createState() => _DoorDeviceDetailScreenState();
}

class _DoorDeviceDetailScreenState extends State<DoorDeviceDetailScreen> {
  late final DoorDeviceApi _api = LocalDoorDeviceApi(client);

  DoorDeviceData? _device;
  DoorDeviceStatusData? _status;
  bool _loading = true;
  bool _testing = false;
  final Set<String> _busyActions = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final devices = await _api.listDevices();
      DoorDeviceData? device;
      for (final candidate in devices) {
        if (candidate.id == widget.deviceId) {
          device = candidate;
          break;
        }
      }
      if (!mounted) return;
      setState(() => _device = device);
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Laden fehlgeschlagen: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _test() async {
    setState(() => _testing = true);
    try {
      final status = await _api.testDevice(id: widget.deviceId);
      if (!mounted) return;
      setState(() => _status = status);
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Test fehlgeschlagen: $e')));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _nukiAction(
    final String actionKey,
    final String title,
    final String confirmText,
  ) async {
    if (_busyActions.contains(actionKey)) return;
    final messenger = ScaffoldMessenger.of(context);
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(confirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ausführen'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;

    setState(() => _busyActions.add(actionKey));
    try {
      final result = switch (actionKey) {
        'unlock' => await _api.unlockNuki(id: widget.deviceId),
        'lock' => await _api.lockNuki(id: widget.deviceId),
        _ => await _api.openNuki(id: widget.deviceId),
      };
      if (!mounted) return;
      setState(() {
        if (result.ok) _status = result;
      });
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.ok
                ? '$title ausgeführt.'
                : 'Fehlgeschlagen: ${result.error ?? 'unbekannt'}',
          ),
        ),
      );
    } on ServerpodClientException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('$title fehlgeschlagen: $e')),
      );
    } finally {
      if (mounted) setState(() => _busyActions.remove(actionKey));
    }
  }

  Future<void> _edit() async {
    final device = _device;
    if (device == null) return;
    final messenger = ScaffoldMessenger.of(context);
    final values = await DoorDeviceDialog.show(
      context,
      initialName: device.name,
      initialAddress: device.address,
    );
    if (values == null) return;
    final (name, address) = values;
    try {
      final updated = await _api.updateDevice(
        id: widget.deviceId,
        name: name,
        address: address,
      );
      if (!mounted) return;
      setState(() => _device = updated);
    } on ServerpodClientException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Speichern fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _pushConfig() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await _api.pushConfig(id: widget.deviceId);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.ok
                ? 'Konfiguration übertragen (MAC: ${result.mac ?? '?'}).'
                : 'Konfiguration fehlgeschlagen: ${result.error ?? '?'}',
          ),
        ),
      );
    } on ServerpodClientException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Konfiguration fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _remove() async {
    final device = _device;
    if (device == null) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerät entfernen'),
        content: Text(
          '"${device.name}" aus der Geräteliste entfernen? Das Gerät selbst '
          'wird nicht verändert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Entfernen'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await _api.removeDevice(id: widget.deviceId);
      if (!mounted) return;
      context.go('/selbsteinlass');
    } on ServerpodClientException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Entfernen fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _openWebInterface() async {
    final device = _device;
    if (device == null) return;
    final url = Uri.parse(doorDeviceWebUrl(device.address));
    if (await launchUrl(url)) return;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Öffnen fehlgeschlagen: $url')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final device = _device;

    if (device == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Gerät')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : const Center(child: Text('Gerät wurde nicht gefunden.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          IconButton(
            tooltip: 'Bearbeiten',
            onPressed: _edit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Gerät entfernen',
            onPressed: _remove,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              const Icon(
                Icons.door_sliding_outlined,
                size: 48,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 4),
              Text(device.name, style: theme.textTheme.headlineSmall),
              Text(device.address, style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 16),
          DoorDeviceStatusCard(
            status: _status,
            testing: _testing,
            onTest: _test,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NUKI-Schloss', style: theme.textTheme.titleMedium),
                  _ActionTile(
                    icon: Icons.lock_open,
                    label: 'Entriegeln',
                    loading: _busyActions.contains('unlock'),
                    onTap: () => _nukiAction(
                      'unlock',
                      'Entriegeln',
                      'Das NUKI-Schloss entriegeln?',
                    ),
                  ),
                  _ActionTile(
                    icon: Icons.door_front_door,
                    label: 'Entsichern (Tür öffnen)',
                    loading: _busyActions.contains('open'),
                    onTap: () => _nukiAction(
                      'open',
                      'Entsichern',
                      'Das Türschloss entsichern (Klappe lösen)? Die Tür '
                          'bleibt danach offen.',
                    ),
                  ),
                  _ActionTile(
                    icon: Icons.lock,
                    label: 'Verriegeln',
                    loading: _busyActions.contains('lock'),
                    onTap: () => _nukiAction(
                      'lock',
                      'Verriegeln',
                      'Das NUKI-Schloss verriegeln?',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Konfiguration senden'),
              subtitle: const Text(
                'Server-Adresse und Site-ID an das Gerät übertragen '
                '(beim Hinzufügen erfolgt das automatisch).',
              ),
              onTap: _pushConfig,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Weboberfläche des Geräts'),
              subtitle: Text(doorDeviceWebUrl(device.address)),
              onTap: _openWebInterface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      trailing: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: loading ? null : onTap,
    );
  }
}
