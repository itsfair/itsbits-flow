import 'package:flutter/material.dart';

/// Self-entry ("Selbsteinlass") screen: the site's locks for door access.
/// Placeholder list for now — the real lock management is implemented
/// together with the doorinterface (ESP32/NUKI) in a later step.
class SelbsteinlassScreen extends StatelessWidget {
  const SelbsteinlassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selbsteinlass')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-lock-fab',
        icon: const Icon(Icons.add),
        label: const Text('Schloss hinzufügen'),
        onPressed: () => _showLockInfo(context),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 48, color: Colors.blueGrey),
            SizedBox(height: 12),
            Text('Noch keine Schlösser eingerichtet.'),
            SizedBox(height: 4),
            Text(
              'Die Schloss-Verwaltung folgt im Zusammenspiel mit dem '
              'doorinterface.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLockInfo(final BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schloss hinzufügen'),
        content: const Text(
          'Das Anlernen von Schlössern wird gemeinsam mit dem doorinterface '
          '(ESP32/NUKI) umgesetzt und steht in einem späteren Schritt zur '
          'Verfügung.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}
