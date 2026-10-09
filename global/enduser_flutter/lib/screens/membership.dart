import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/screens/site_detail_body.dart';
import 'package:itsbits_shared/site_directory.dart';

import '../client.dart';

/// The end user's membership at a site: the site snapshot plus their own
/// membership data and an access-token section (BLE door access arrives in
/// a later step). Unsubscribing only sets a marker — the data stays for
/// later viewing (backend behaviour).
class MembershipScreen extends StatefulWidget {
  final int siteId;

  const MembershipScreen({required this.siteId, super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  SiteData? _site;
  MyMembershipData? _membership;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final futures = await Future.wait([
        siteDirectoryApi.getSite(widget.siteId),
        siteDirectoryApi.myMembership(widget.siteId),
      ]);
      if (!mounted) return;
      setState(() {
        _site = futures[0] as SiteData;
        _membership = futures[1] as MyMembershipData?;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laden fehlgeschlagen: $e')),
      );
      if (mounted) context.go('/sites');
    }
  }

  @override
  Widget build(final BuildContext context) {
    final site = _site;
    final membership = _membership;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Mitgliedschaft'),
      ),
      body: site == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SiteDetailBody(site: site),
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
                        Text(
                          'Rolle: ${_roleLabel(membership?.roleName ?? 'member')}',
                        ),
                        Text(
                          'Mitglied seit: '
                          '${_dateText(membership?.createdAt)}',
                        ),
                        if (membership?.endedAt case final ended?)
                          Text(
                            'Beendet am: ${_dateText(ended)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.lock_outline),
                    title: Text('Zugangsberechtigung'),
                    subtitle: Text(
                      'Türöffnung am Standort. Deine Zugangsdaten liegen '
                      'bereits an der Site vor (Einrichtung folgt mit dem '
                      'BLE-Zutritt in einem späteren Schritt).',
                    ),
                    trailing: Icon(Icons.hourglass_bottom, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                if (_membership?.active ?? false)
                  OutlinedButton(
                    onPressed: _busy ? null : _confirmUnsubscribe,
                    child: const Text('Mitgliedschaft beenden'),
                  ),
              ],
            ),
    );
  }

  Future<void> _confirmUnsubscribe() async {
    final agreed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mitgliedschaft beenden?'),
        content: const Text(
          'Deine Mitgliedschaft wird beendet und die Site erfährt davon '
          'mit der nächsten Datenübergabe. Deine Daten bleiben beim '
          'Betreiber gespeichert (nur deaktiviert), damit späterer Einblick '
          'möglich bleibt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await siteDirectoryApi.unsubscribe(widget.siteId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mitgliedschaft beendet '
            '(Daten bleiben beim Betreiber gespeichert, nur deaktiviert).',
          ),
        ),
      );
      await _load();
      if (mounted) context.go('/site/${widget.siteId}');
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Beenden fehlgeschlagen: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _roleLabel(final String roleName) => switch (roleName) {
    'staff' => 'Mitarbeiter',
    'siteAdmin' => 'Site-Admin',
    _ => 'Mitglied',
  };

  String _dateText(final DateTime? dateTime) {
    if (dateTime == null) return 'unbekannt';
    return '${dateTime.day.toString().padLeft(2, '0')}.'
        '${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
  }
}
