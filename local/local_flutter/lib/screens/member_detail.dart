import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../client.dart';
import 'members.dart' show roleLabelOf;

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
              ],
            ),
    );
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
