import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../client.dart';

/// Number of members loaded per page (mirrors MembersAdminEndpoint.pageSize).
const int _pageSize = 50;

/// Lists the local member directory (mirror of the global membership
/// propagation): search + pagination, per-person card with the
/// role/active chips from the local membership mirror.
class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<MemberSummary> _items = [];
  int _total = 0;
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
    });
    try {
      final items = await client.membersAdmin.listMembers(
        query: _query,
        offset: 0,
        limit: _pageSize,
      );
      final total = await client.membersAdmin.countMembers(query: _query);
      if (!mounted) return;
      setState(() {
        _items = items;
        _total = total;
      });
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final items = await client.membersAdmin.listMembers(
        query: _query,
        offset: _items.length,
        limit: _pageSize,
      );
      final total = await client.membersAdmin.countMembers(query: _query);
      if (!mounted) return;
      setState(() {
        _items.addAll(items);
        _total = total;
      });
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laden fehlgeschlagen: $e')),
      );
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _onSearchChanged(String value) {
    final text = value.trim();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (text == _searchController.text.trim() && text != _query) {
        _query = text;
        _loadFirstPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMore = _items.length < _total;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Suche nach E-Mail oder Name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              IconButton(
                tooltip: 'Neu laden',
                onPressed: _loading ? null : _loadFirstPage,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Laden fehlgeschlagen: $_error',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          )
        else if (_loading)
          const Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          )
        else ...[
          if (hasMore)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Es gibt $_total Member, ${_items.length} geladen — '
                'weitere laden oder Suche verfeinern.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Keine Member gefunden.'))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final member = _items[index];
                      return Card(
                        child: ListTile(
                          leading: member.imageUrl != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    member.imageUrl!,
                                  ),
                                )
                              : const Icon(Icons.person_outline),
                          title: Text(
                            memberName(member) ?? member.email,
                          ),
                          subtitle: Text(member.email),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              if (member.roleName case final role?)
                                Chip(label: Text(_roleLabel(role))),
                              if (member.active case false)
                                const Chip(label: Text('beendet')),
                            ],
                          ),
                          onTap: () => context.go(
                            '/members/${member.globalAuthUserId.uuid}',
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (hasMore)
            Center(
              child: _loadingMore
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OutlinedButton(
                        onPressed: _loadMore,
                        child: Text('Weitere $_pageSize laden'),
                      ),
                    ),
            ),
        ],
      ],
    );
  }
}

/// Shared display helper (list + detail screens).
String? memberName(final MemberSummary member) {
  final parts =
      [
            member.firstName,
            member.lastName,
          ]
          .whereType<String>()
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty);
  return parts.isEmpty ? null : parts.join(' ');
}

/// Role label mapping (mirror of the global SiteRole).
String roleLabelOf(final String roleName) => switch (roleName) {
  'staff' => 'Mitarbeiter',
  'siteAdmin' => 'Site-Admin',
  _ => 'Mitglied',
};

String _roleLabel(final String roleName) => roleLabelOf(roleName);
