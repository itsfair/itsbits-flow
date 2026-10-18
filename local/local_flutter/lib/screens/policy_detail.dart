import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/door_device_directory.dart';

import '../client.dart';
import '../door_device_api.dart';
import 'members.dart' show memberName;
import 'policies.dart';

/// Policy detail/editor: rename, manage the rules (door × weekday ×
/// minute window) and the member assignments (each with its own validity
/// period). Every mutation goes through a dedicated endpoint call and
/// reloads the detail.
class PolicyDetailScreen extends StatefulWidget {
  final int policyId;

  const PolicyDetailScreen({required this.policyId, super.key});

  @override
  State<PolicyDetailScreen> createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends State<PolicyDetailScreen> {
  DoorPolicyDetail? _policy;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final policy = await client.doorPolicyAdmin.getPolicy(
        id: widget.policyId,
      );
      if (!mounted) return;
      setState(() => _policy = policy);
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Laden fehlgeschlagen: $e')));
      context.go('/self-entry/policies');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onError(final String action, final Object e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action fehlgeschlagen: $e')));
  }

  // -- Name

  Future<void> _rename() async {
    final policy = _policy;
    if (policy == null) return;
    final name = await showPolicyNameDialog(context, initial: policy.name);
    if (name == null) return;
    try {
      await client.doorPolicyAdmin.updatePolicy(id: policy.id, name: name);
      await _load();
    } on ServerpodClientException catch (e) {
      _onError('Umbenennen', e);
    }
  }

  Future<void> _remove() async {
    final policy = _policy;
    if (policy == null) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berechtigung löschen?'),
        content: Text(
          '"${policy.name}" samt Regeln und Zuweisungen löschen? Die '
          'zugewiesenen Mitglieder verlieren damit den Türzugang (sofern '
          'keine weitere Berechtigung vorliegt).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    try {
      await client.doorPolicyAdmin.removePolicy(id: widget.policyId);
      if (!mounted) return;
      context.go('/self-entry/policies');
    } on ServerpodClientException catch (e) {
      _onError('Löschen', e);
    }
  }

  // -- Rules

  Future<void> _addRules() async {
    final rule = await _showRuleDialog(null);
    if (rule == null) return;
    try {
      await client.doorPolicyAdmin.addRule(
        policyId: widget.policyId,
        deviceId: rule.deviceId,
        weekdays: rule.weekdays,
        startMinute: rule.startMinute,
        endMinute: rule.endMinute,
      );
      await _load();
    } on ServerpodClientException catch (e) {
      _onError('Regel hinzufügen', e);
    }
  }

  Future<void> _editRule(final DoorPolicyRuleData rule) async {
    final edited = await _showRuleDialog(rule);
    if (edited == null) return;
    try {
      await client.doorPolicyAdmin.updateRule(
        ruleId: rule.id,
        deviceId: edited.deviceId,
        weekday: edited.weekdays.first,
        startMinute: edited.startMinute,
        endMinute: edited.endMinute,
      );
      await _load();
    } on ServerpodClientException catch (e) {
      _onError('Regel speichern', e);
    }
  }

  Future<void> _removeRule(final DoorPolicyRuleData rule) async {
    try {
      await client.doorPolicyAdmin.removeRule(ruleId: rule.id);
      await _load();
    } on ServerpodClientException catch (e) {
      _onError('Regel löschen', e);
    }
  }

  // -- Assignments

  Future<void> _addMember() async {
    final picked = await _showMemberPicker();
    if (picked == null) return;
    final period = await _showValidityDialog(null);
    if (period == null) return;
    try {
      await client.doorPolicyAdmin.addMemberAssignment(
        policyId: widget.policyId,
        globalAuthUserId: UuidValue.fromString(picked),
        validFrom: period.$1,
        validUntil: period.$2,
      );
      await _load();
    } on ServerpodClientException catch (e) {
      _onError('Mitglied hinzufügen', e);
    }
  }

  Future<void> _editAssignment(final DoorPolicyMemberData member) async {
    final period = await _showValidityDialog(member);
    if (period == null) return;
    try {
      await client.doorPolicyAdmin.updateMemberAssignment(
        assignmentId: member.id,
        validFrom: period.$1,
        validUntil: period.$2,
      );
      await _load();
    } on ServerpodClientException catch (e) {
      _onError('Zeitraum speichern', e);
    }
  }

  Future<void> _removeAssignment(final DoorPolicyMemberData member) async {
    try {
      await client.doorPolicyAdmin.removeMemberAssignment(
        assignmentId: member.id,
      );
      await _load();
    } on ServerpodClientException catch (e) {
      _onError('Mitglied entfernen', e);
    }
  }

  // -- Build

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final policy = _policy;

    if (_loading && policy == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Berechtigung')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (policy == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Berechtigung')),
        body: const Center(child: Text('Berechtigung wurde nicht gefunden.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(policy.name),
        actions: [
          IconButton(
            tooltip: 'Umbenennen',
            onPressed: _rename,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Löschen',
            onPressed: _remove,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _rulesCard(theme, policy),
          const SizedBox(height: 16),
          _membersCard(theme, policy),
        ],
      ),
    );
  }

  Widget _rulesCard(final ThemeData theme, final DoorPolicyDetail policy) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Regeln', style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  tooltip: 'Regel hinzufügen',
                  onPressed: _addRules,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (policy.rules.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Keine Regeln — diese Berechtigung gewährt noch keinen '
                  'Zugang.',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              )
            else
              for (final rule in policy.rules)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    '${kWeekdayNames[rule.weekday]} '
                    '${ruleRangeText(rule.startMinute, rule.endMinute)}',
                  ),
                  subtitle: Text(rule.deviceName ?? 'Alle Türen'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Bearbeiten',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _editRule(rule),
                      ),
                      IconButton(
                        tooltip: 'Löschen',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeRule(rule),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _membersCard(final ThemeData theme, final DoorPolicyDetail policy) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Mitglieder', style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  tooltip: 'Mitglied hinzufügen',
                  onPressed: _addMember,
                  icon: const Icon(Icons.person_add_alt),
                ),
              ],
            ),
            if (policy.members.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Keine Mitglieder zugewiesen.',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              )
            else
              for (final member in policy.members)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.person_outline),
                  title: Text(
                    personName(member.firstName, member.lastName) ??
                        member.email,
                  ),
                  subtitle: Text(
                    '${member.email}\n'
                    '${validityText(member.validFrom, member.validUntil)}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Zeitraum bearbeiten',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _editAssignment(member),
                      ),
                      IconButton(
                        tooltip: 'Entfernen',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeAssignment(member),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  // -- Dialogs

  Future<List<DoorDeviceData>> _loadDevices() async {
    try {
      return await LocalDoorDeviceApi(client).listDevices();
    } on ServerpodClientException {
      return [];
    }
  }

  Future<({int? deviceId, List<int> weekdays, int startMinute, int endMinute})?>
  _showRuleDialog(final DoorPolicyRuleData? existing) async {
    final devices = await _loadDevices();
    if (!mounted) return null;

    int? deviceId = existing?.deviceId;
    var startMinute = existing?.startMinute ?? 17 * 60;
    var endMinute = existing?.endMinute ?? 20 * 60;
    Set<int> weekdays = {existing?.weekday ?? 0};

    final result =
        await showDialog<
          ({int? deviceId, int startMinute, int endMinute, List<int> weekdays})
        >(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                Future<void> pickTime({required bool isStart}) async {
                  final current = isStart ? startMinute : endMinute;
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: current ~/ 60 % 24,
                      minute: current % 60,
                    ),
                  );
                  if (picked == null) return;
                  final value = picked.hour * 60 + picked.minute;
                  setDialogState(() {
                    if (isStart) {
                      startMinute = value;
                    } else {
                      // 00:00 als Ende = Mitternacht (24:00).
                      endMinute = value == 0 && startMinute > 0 ? 1440 : value;
                    }
                  });
                }

                return AlertDialog(
                  title: Text(
                    existing == null ? 'Regel hinzufügen' : 'Regel bearbeiten',
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<int?>(
                        initialValue: deviceId,
                        decoration: const InputDecoration(labelText: 'Tür'),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Alle Türen'),
                          ),
                          for (final device in devices)
                            DropdownMenuItem(
                              value: device.id,
                              child: Text(device.name),
                            ),
                        ],
                        onChanged: (value) =>
                            setDialogState(() => deviceId = value),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: [
                          for (var w = 0; w < 7; w++)
                            ChoiceChip(
                              label: Text(kWeekdayShort[w]),
                              selected: weekdays.contains(w),
                              onSelected: (selected) => setDialogState(() {
                                if (existing == null) {
                                  selected
                                      ? weekdays.add(w)
                                      : weekdays.remove(w);
                                } else {
                                  weekdays
                                    ..clear()
                                    ..add(w);
                                }
                              }),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => pickTime(isStart: true),
                              child: Text('ab ${minuteText(startMinute)}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => pickTime(isStart: false),
                              child: Text('bis ${minuteText(endMinute)}'),
                            ),
                          ),
                        ],
                      ),
                      if (endMinute <= startMinute)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Das Ende muss nach dem Beginn liegen '
                            '(00:00 = Mitternacht).',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Abbrechen'),
                    ),
                    FilledButton(
                      onPressed: endMinute <= startMinute
                          ? null
                          : () => Navigator.of(context).pop((
                              deviceId: deviceId,
                              startMinute: startMinute,
                              endMinute: endMinute,
                              weekdays: weekdays.toList(),
                            )),
                      child: const Text('Speichern'),
                    ),
                  ],
                );
              },
            );
          },
        );
    if (result == null) return null;
    return (
      deviceId: result.deviceId,
      weekdays: result.weekdays,
      startMinute: result.startMinute,
      endMinute: result.endMinute,
    );
  }

  Future<(DateTime, DateTime?)?> _showValidityDialog(
    final DoorPolicyMemberData? existing,
  ) async {
    var fromDate = existing?.validFrom ?? DateTime.now();
    DateTime? untilDate = existing?.validUntil;

    final result = await showDialog<(DateTime, DateTime?)?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickDate({required bool isFrom}) async {
              final initial = isFrom ? fromDate : (untilDate ?? fromDate);
              final picked = await showDatePicker(
                context: context,
                initialDate: initial,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked == null) return;
              setDialogState(() {
                if (isFrom) {
                  fromDate = picked;
                } else {
                  untilDate = picked;
                }
              });
            }

            return AlertDialog(
              title: Text(
                existing == null ? 'Zeitraum' : 'Zeitraum bearbeiten',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => pickDate(isFrom: true),
                    child: Text('Gültig ab: ${dateText(fromDate)}'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => pickDate(isFrom: false),
                          child: Text(
                            untilDate == null
                                ? 'Gültig bis: unbegrenzt'
                                : 'Gültig bis: ${dateText(untilDate!)}',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Ende entfernen (unbegrenzt)',
                        onPressed: () => setDialogState(() => untilDate = null),
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
                  onPressed: () => Navigator.of(context).pop((
                    fromDate,
                    untilDate,
                  )),
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

  Future<String?> _showMemberPicker() async {
    final policy = _policy;
    if (policy == null) return null;
    final assignedIds = policy.members
        .map((m) => m.globalAuthUserId.uuid)
        .toSet();

    MemberSummary? picked;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        var query = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<List<MemberSummary>> load() async {
              final members = await client.membersAdmin.listMembers(
                query: query,
                offset: 0,
                limit: 50,
              );
              return members
                  .where(
                    (m) => !assignedIds.contains(m.globalAuthUserId.uuid),
                  )
                  .toList();
            }

            return SizedBox(
              height: 480,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Suche nach E-Mail oder Name',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (value) =>
                          setSheetState(() => query = value.trim()),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<MemberSummary>>(
                      future: load(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final members = snapshot.data!;
                        if (members.isEmpty) {
                          return const Center(
                            child: Text('Keine Member gefunden.'),
                          );
                        }
                        return ListView(
                          children: [
                            for (final member in members)
                              ListTile(
                                leading: const Icon(Icons.person_outline),
                                title: Text(
                                  memberName(member) ?? member.email,
                                ),
                                subtitle: Text(member.email),
                                onTap: () {
                                  picked = member;
                                  Navigator.of(sheetContext).pop();
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    return picked?.globalAuthUserId.uuid;
  }
}
