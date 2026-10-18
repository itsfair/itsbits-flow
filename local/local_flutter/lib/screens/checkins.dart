import 'package:flutter/material.dart';

/// "Check-ins" — the self-entry overview (who entered when). The real
/// check-in list is built in a later step; the path is the drawer's
/// section entry point.
class CheckinsScreen extends StatelessWidget {
  const CheckinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-ins')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fact_check_outlined, size: 48, color: Colors.blueGrey),
            SizedBox(height: 12),
            Text(
              'Die Übersicht der Check-ins folgt in einem späteren Schritt.',
            ),
          ],
        ),
      ),
    );
  }
}
