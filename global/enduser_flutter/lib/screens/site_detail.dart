import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/screens/membership_terms_dialog.dart';
import 'package:itsbits_shared/screens/site_detail_body.dart';
import 'package:itsbits_shared/site_directory.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';

/// Detail view of a site for end users: shared display body plus the
/// membership FAB bottom right.
///
/// FAB states: signed out -> "Anmelden" (deep link keep working even with
/// unauthenticated browsing); no membership yet -> "Abonnieren" (only
/// enabled while the site is online — the backend enforces this too);
/// already subscribed -> "Meine Mitgliedschaft" (navigates to the
/// membership screen); deactivated membership -> "Erneut abonnieren"
/// (reactivates in place — history is kept server-side).
class SiteDetailScreen extends StatefulWidget {
  final int siteId;

  const SiteDetailScreen({required this.siteId, super.key});

  @override
  State<SiteDetailScreen> createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen> {
  SiteData? _site;
  MyMembershipData? _membership;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final site = await siteDirectoryApi.getSite(widget.siteId);
      final membership = await siteDirectoryApi.myMembership(widget.siteId);
      if (!mounted) return;
      setState(() {
        _site = site;
        _membership = membership;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    }
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Laden fehlgeschlagen: $_error'),
              TextButton(
                onPressed: () => context.go('/sites'),
                child: const Text('Zur Liste'),
              ),
            ],
          ),
        ),
      );
    }

    final site = _site;
    return Scaffold(
      appBar: AppBar(title: Text(site?.name ?? 'Site')),
      floatingActionButton: site == null
          ? null
          : _buildFab(context, theme, site),
      body: site == null
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context, site),
    );
  }

  Widget _buildBody(final BuildContext context, final SiteData site) {
    final theme = Theme.of(context);
    final membership = _membership;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SiteDetailBody(site: site),
        const SizedBox(height: 16),
        if (membership case final membership?)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                membership.active
                    ? 'Du bist Mitglied bei dieser Site.'
                    : 'Deine Mitgliedschaft war beendet '
                          '(${(_dateText(membership.endedAt))}). '
                          'Du kannst sie hier erneut abschließen.',
                style: membership.active
                    ? theme.textTheme.bodyMedium
                    : theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFab(
    final BuildContext context,
    final ThemeData theme,
    final SiteData site,
  ) {
    if (!client.auth.isAuthenticated) {
      return FloatingActionButton.extended(
        heroTag: 'site-fab-${site.id}',
        icon: const Icon(Icons.login),
        label: const Text('Anmelden'),
        onPressed: () => context.push('/sign-in'),
      );
    }

    final membership = _membership;
    final subscribed = membership != null && membership.active;

    if (subscribed) {
      return FloatingActionButton.extended(
        heroTag: 'site-fab-${site.id}',
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
        icon: const Icon(Icons.badge_outlined),
        label: const Text('Meine Mitgliedschaft'),
        onPressed: () => context.push('/membership/${site.id}'),
      );
    }

    final subscribing = membership != null;
    final enabled = site.isOnline && !_busy;
    return FloatingActionButton.extended(
      heroTag: 'site-fab-${site.id}',
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      icon: const Icon(Icons.workspace_premium_outlined),
      label: Text(subscribing ? 'Erneut abonnieren' : 'Abonnieren'),
      onPressed: enabled
          ? () => _confirmAndSubscribe(site, reactivating: subscribing)
          : null,
    );
  }

  Future<void> _confirmAndSubscribe(
    final SiteData site, {
    required final bool reactivating,
  }) async {
    final agreed = await showMembershipTermsDialog(
      context,
      siteName: site.name,
      companyEmail: site.companyEmail,
    );
    if (!agreed || !mounted) return;

    setState(() => _busy = true);
    try {
      await siteDirectoryApi.subscribe(site.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mitgliedschaft abgeschlossen \u2014 die Daten '
            'werden an die Site übertragen.',
          ),
        ),
      );
      await _load();
      if (!mounted) return;
      context.push('/membership/${site.id}');
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reactivating
                ? 'Reaktivierung fehlgeschlagen: $e'
                : 'Abonnieren fehlgeschlagen: $e',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _dateText(final DateTime? dateTime) {
    if (dateTime == null) return 'unbekannt';
    return '${dateTime.day.toString().padLeft(2, '0')}.'
        '${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
  }
}
