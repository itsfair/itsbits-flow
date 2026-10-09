import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home: overview placeholder — content (device/members overview) is filled
/// in a later step; navigation happens via the drawer.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Übersicht (Inhalt folgt in einem späteren Schritt)'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go('/members'),
            icon: const Icon(Icons.people),
            label: const Text('Members'),
          ),
        ],
      ),
    );
  }
}
