import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/door_device_directory.dart';
import 'package:itsbits_shared/widgets/door_device_dialog.dart';

import '../client.dart';
import '../door_device_api.dart';

/// "Selbsteinlass" — the LAN registry of this site's doorinterface
/// devices (ESP32). Cards list name + address; tapping opens the detail
/// screen (connection test, NUKI actions, edit/remove). Devices are added
/// by hand for now (MVP: LAN-only, no pairing machinery).
class SelbsteinlassScreen extends StatefulWidget {
  const SelbsteinlassScreen({super.key});

  @override
  State<SelbsteinlassScreen> createState() => _SelbsteinlassScreenState();
}

class _SelbsteinlassScreenState extends State<SelbsteinlassScreen> {
  late final DoorDeviceApi _api = LocalDoorDeviceApi(client);

  List<DoorDeviceData> _devices = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final devices = await _api.listDevices();
      if (!mounted) return;
      setState(() => _devices = devices);
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addDevice() async {
    final messenger = ScaffoldMessenger.of(context);
    final values = await DoorDeviceDialog.show(context);
    if (values == null) return;
    final (name, address) = values;
    try {
      await _api.addDevice(name: name, address: address);
      await _load();
    } on ServerpodClientException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Hinzufügen fehlgeschlagen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Selbsteinlass')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-device-fab',
        icon: const Icon(Icons.add),
        label: const Text('Gerät hinzufügen'),
        onPressed: _addDevice,
      ),
      body: _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Laden fehlgeschlagen: $_error',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _load,
                    child: const Text('Erneut versuchen'),
                  ),
                ],
              ),
            )
          : _loading
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.door_sliding_outlined,
                    size: 48,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(height: 12),
                  const Text('Noch keine Geräte eingetragen.'),
                  const SizedBox(height: 4),
                  Text(
                    'Trage die LAN-Adresse eines doorinterface ein '
                    '(IP oder hostname.local).',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                children: [
                  for (final device in _devices)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.door_sliding_outlined),
                        title: Text(device.name),
                        subtitle: Text(device.address),
                        onTap: () => context.go('/selbsteinlass/${device.id}'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
