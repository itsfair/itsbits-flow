import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../client.dart';
import 'members.dart' show roleLabelOf;
import 'policies.dart' show showPolicyNameDialog, validityText;

/// Read-only detail of a local member: person mirror data (incl. the
/// exchange/door id with QR) plus the membership mirror
/// (role/active/endedAt). No login chip — logins live in the account
/// dropdown, not per member. Editing happens globally only (sync rule).
class MemberDetailScreen extends StatefulWidget {
  final String globalAuthUserId;

  const MemberDetailScreen({required this.globalAuthUserId, super.key});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  MemberDetail? _member;
  String? _error;
  List<MemberPolicyAssignmentData> _assignments = [];
  String? _policiesError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final member = await client.membersAdmin.getMember(
        globalAuthUserId: UuidValue.fromString(widget.globalAuthUserId),
      );
      if (!mounted) return;
      setState(() => _member = member);
      await _loadAssignments();
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final member = _member;
    final name = member == null
        ? null
        : [
            member.firstName,
            member.lastName,
          ].whereType<String>().join(' ').trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(name == null || name.isEmpty ? 'Member' : name),
      ),
      body: member == null
          ? Center(
              child: _error != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Laden fehlgeschlagen: $_error'),
                      ],
                    )
                  : const CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: member.imageUrl != null
                      ? CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(member.imageUrl!),
                        )
                      : const Icon(Icons.person_outline, size: 64),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    name == null || name.isEmpty
                        ? '(kein Name im Profil)'
                        : name,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                _propertyLine('E-Mail', member.email),
                if (member.birthday case final birthday?)
                  _propertyLine('Geburtstag', _dateText(birthday)),
                _propertyLine(
                  'Person-ID (Tür-Schlüssel)',
                  member.globalAuthUserId.uuid,
                ),
                const SizedBox(height: 8),
                Center(
                  child: QrImageView(
                    data: member.globalAuthUserId.uuid,
                    version: QrVersions.auto,
                    size: 160,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mitgliedschaft',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (member.roleName case final role?) ...[
                          Text('Rolle: ${roleLabelOf(role)}'),
                          Text(
                            member.active == true
                                ? 'Status: aktiv'
                                : 'Status: beendet'
                                      '${member.endedAt != null ? ' am ${_dateText(member.endedAt!)}' : ''}',
                          ),
                          if (member.membershipCreatedAt case final createdAt?)
                            Text('Mitglied seit: ${_dateText(createdAt)}'),
                        ] else
                          const Text(
                            '(keine Mitgliedschaft bekannt)',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _policiesCard(theme),
              ],
            ),
    );
  }

  /// The member's policy assignments ("Zugangsberechtigungen"): linked
  /// tiles into the policy details, plus add-existing (picker) and
  /// create-new (name dialog → assign) actions.
  Widget _policiesCard(final ThemeData theme) {
    final assignments = _assignments;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Zugangsberechtigungen',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Bestehende hinzufügen',
                  onPressed: _addExistingPolicy,
                  icon: const Icon(Icons.playlist_add),
                ),
                IconButton(
                  tooltip: 'Neu erstellen & zuweisen',
                  onPressed: _createAndAssignPolicy,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            if (_policiesError != null)
              Text(
                _policiesError!,
                style: TextStyle(color: theme.colorScheme.error),
              )
            else if (assignments.isEmpty)
              const Text(
                'Keine Berechtigung zugewiesen — ohne Zuweisung ist der '
                'Türzugang gesperrt.',
                style: TextStyle(color: Colors.blueGrey),
              )
            else
              for (final assignment in assignments)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.policy_outlined),
                  title: Text(assignment.policyName),
                  subtitle: Text(
                    validityText(assignment.validFrom, assignment.validUntil),
                  ),
                  onTap: () => context.go(
                    '/self-entry/policies/${assignment.policyId}',
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadAssignments() async {
    final member = _member;
    if (member == null) return;
    try {
      final result = await client.doorPolicyAdmin.listPoliciesFor(
        globalAuthUserId: member.globalAuthUserId,
      );
      if (!mounted) return;
      setState(() => _assignments = result);
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      setState(() => _policiesError = '$e');
    }
  }

  Future<void> _addExistingPolicy() async {
    final member = _member;
    if (member == null) return;
    final policyId = await _pickPolicyForAssignment();
    if (policyId == null) return;
    final period = await _pickValidityPeriod();
    if (period == null) return;
    try {
      await client.doorPolicyAdmin.addMemberAssignment(
        policyId: policyId,
        globalAuthUserId: member.globalAuthUserId,
        validFrom: period.$1,
        validUntil: period.$2,
      );
      await _loadAssignments();
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Zuweisen fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _createAndAssignPolicy() async {
    final member = _member;
    if (member == null) return;
    final name = await showPolicyNameDialog(context);
    if (name == null) return;
    final period = await _pickValidityPeriod();
    if (period == null) return;
    try {
      final policy = await client.doorPolicyAdmin.createPolicy(name: name);
      await client.doorPolicyAdmin.addMemberAssignment(
        policyId: policy.id,
        globalAuthUserId: member.globalAuthUserId,
        validFrom: period.$1,
        validUntil: period.$2,
      );
      await _loadAssignments();
      if (!mounted) return;
      context.go('/self-entry/policies/${policy.id}');
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erstellen fehlgeschlagen: $e')),
      );
    }
  }

  Future<int?> _pickPolicyForAssignment() async {
    try {
      final all = await client.doorPolicyAdmin.listPolicies();
      final assigned = _assignments.map((a) => a.policyId).toSet();
      final candidates = all.where((p) => !assigned.contains(p.id)).toList();
      if (!mounted) return null;
      return await showModalBottomSheet<int>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return SizedBox(
            height: 360,
            child: candidates.isEmpty
                ? const Center(child: Text('Keine weiteren Berechtigungen.'))
                : ListView(
                    children: [
                      for (final policy in candidates)
                        ListTile(
                          leading: const Icon(Icons.policy_outlined),
                          title: Text(policy.name),
                          subtitle: Text(
                            '${policy.ruleCount} Regeln · '
                            '${policy.memberCount} Mitglieder',
                          ),
                          onTap: () => Navigator.of(context).pop(policy.id),
                        ),
                    ],
                  ),
          );
        },
      );
    } on ServerpodClientException catch (e) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laden fehlgeschlagen: $e')),
      );
      return null;
    }
  }

  Future<(DateTime, DateTime?)?> _pickValidityPeriod() async {
    var from = DateTime.now();
    DateTime? until;

    final result = await showDialog<(DateTime, DateTime?)?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickDate({required bool isFrom}) async {
              final picked = await showDatePicker(
                context: context,
                initialDate: isFrom ? from : (until ?? from),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked == null) return;
              setDialogState(() {
                if (isFrom) {
                  from = picked;
                } else {
                  until = picked;
                }
              });
            }

            return AlertDialog(
              title: const Text('Zeitraum'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => pickDate(isFrom: true),
                    child: Text('Gültig ab: ${_dateText(from)}'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => pickDate(isFrom: false),
                          child: Text(
                            until == null
                                ? 'Gültig bis: unbegrenzt'
                                : 'Gültig bis: ${_dateText(until!)}',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Ende entfernen (unbegrenzt)',
                        onPressed: () => setDialogState(() => until = null),
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop((from, until)),
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result == null) return null;
    final (pickedFrom, pickedUntil) = result;
    if (pickedUntil != null && !pickedUntil.isAfter(pickedFrom)) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Das Ende muss nach dem Beginn liegen.')),
      );
      return null;
    }
    return (pickedFrom, pickedUntil);
  }

  Widget _propertyLine(final String label, final String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
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

  String _dateText(final DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.'
        '${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
  }
}
