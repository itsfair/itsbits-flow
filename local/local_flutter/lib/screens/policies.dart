import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../client.dart';

/// "Zugangsberechtigung" — the access policy list (deny-by-default: a
/// member can only open doors through an assigned policy). Same list
/// style as the members/locks screens.
class PoliciesScreen extends StatefulWidget {
  const PoliciesScreen({super.key});

  @override
  State<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends State<PoliciesScreen> {
  List<DoorPolicySummary> _policies = [];
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
      final policies = await client.doorPolicyAdmin.listPolicies();
      if (!mounted) return;
      setState(() => _policies = policies);
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    final messenger = ScaffoldMessenger.of(context);
    final name = await showPolicyNameDialog(context);
    if (name == null) return;
    try {
      final policy = await client.doorPolicyAdmin.createPolicy(name: name);
      if (!mounted) return;
      context.go('/self-entry/policies/${policy.id}');
    } on ServerpodClientException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Erstellen fehlgeschlagen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Zugangsberechtigung')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-policy-fab',
        icon: const Icon(Icons.add),
        label: const Text('Berechtigung erstellen'),
        onPressed: _create,
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
          : _policies.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.policy_outlined,
                    size: 48,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(height: 12),
                  const Text('Noch keine Berechtigungen angelegt.'),
                  const SizedBox(height: 4),
                  const Text(
                    'Ohne zugewiesene Berechtigung kann niemand die Tür '
                    'öffnen.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                children: [
                  for (final policy in _policies)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.policy_outlined),
                        title: Text(policy.name),
                        subtitle: Text(
                          '${policy.ruleCount} Regeln · '
                          '${policy.memberCount} Mitglieder',
                        ),
                        onTap: () => context.go(
                          '/self-entry/policies/${policy.id}',
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

// -- Shared display helpers (list + detail + member screens)

const List<String> kWeekdayNames = [
  'Montag',
  'Dienstag',
  'Mittwoch',
  'Donnerstag',
  'Freitag',
  'Samstag',
  'Sonntag',
];

const List<String> kWeekdayShort = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

/// Minutes since midnight → "HH:mm" (1440 → "24:00").
String minuteText(final int minute) {
  final m = minute.clamp(0, 1440);
  return '${(m ~/ 60).toString().padLeft(2, '0')}:'
      '${(m % 60).toString().padLeft(2, '0')}';
}

String ruleRangeText(final int startMinute, final int endMinute) =>
    '${minuteText(startMinute)}–${minuteText(endMinute)}';

String validityText(final DateTime from, final DateTime? until) {
  return 'ab ${dateText(from)}'
      '${until == null ? ' · unbegrenzt' : ' · bis ${dateText(until)}'}';
}

String dateText(final DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}.'
      '${dateTime.month.toString().padLeft(2, '0')}.'
      '${dateTime.year}';
}

String? personName(final String? firstName, final String? lastName) {
  final parts = [firstName, lastName]
      .whereType<String>()
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty);
  return parts.isEmpty ? null : parts.join(' ');
}

/// Name dialog for creating/renaming a policy. Returns the trimmed name
/// or null when cancelled.
Future<String?> showPolicyNameDialog(
  final BuildContext context, {
  final String? initial,
}) {
  final controller = TextEditingController(text: initial ?? '');
  final formKey = GlobalKey<FormState>();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(initial == null ? 'Berechtigung erstellen' : 'Umbenennen'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) => (value ?? '').trim().isEmpty
              ? 'Bitte einen Namen angeben.'
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() != true) return;
            Navigator.of(context).pop(controller.text.trim());
          },
          child: const Text('Speichern'),
        ),
      ],
    ),
  );
}
