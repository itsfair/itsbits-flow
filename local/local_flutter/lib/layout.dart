import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/widgets/account_dropdown.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'main.dart';

/// Shell layout of the site admin app.
///
/// Visible surface follows the connection state:
/// - `noneSetup` / `needsReSetup`: the setup mask is the whole app (no
///   drawer, no login dropdown).
/// - enrolled + not signed in: login dropdown button in the AppBar.
/// - enrolled + signed in: avatar dropdown + drawer (free navigation).
class Layout extends StatefulWidget {
  final Widget child;

  const Layout({required this.child, super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  SiteConnectionInfo? _status;
  String? _error;
  Timer? _pollTimer;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _refreshStatus();
    });
    client.auth.authInfoListenable.addListener(_updateAuthState);
    _updateAuthState();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    client.auth.authInfoListenable.removeListener(_updateAuthState);
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    try {
      final status = await client.siteSetup.connectionStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _error = null;
      });
      connectionStateNotifier.value = status.state;
    } on ServerpodClientException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _updateAuthState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  void _goTo(final String location) {
    context.go(location);
  }

  /// True while the setup mask must be the whole app.
  bool get _setupNeeded =>
      _status == null ||
      switch (_status?.state) {
        SiteConnectionState.noneSetup ||
        SiteConnectionState.needsReSetup => true,
        _ => false,
      };

  @override
  Widget build(BuildContext context) {
    // Profile data changes (image/name sync from global) re-render the
    // dropdown avatar.
    return ListenableBuilder(
      listenable: profileState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Standort-Verwaltung'),
            backgroundColor: Colors.blue[900],
            foregroundColor: Colors.white,
            actions: [
              if (!_setupNeeded)
                AccountDropdown(
                  isSignedIn: _isSignedIn,
                  fullName: profileState.fullName,
                  imageUrl: profileState.imageUrl,
                  extraItems: [
                    AccountMenuItem(
                      value: 'standort',
                      title: 'Standort',
                      icon: Icons.location_city,
                      onTap: (context) => context.go('/standort'),
                    ),
                  ],
                  onLogin: (context) => context.go('/sign-in'),
                  onLogout: () => client.auth.signOutDevice(),
                  onProfile: (context) => context.go('/profile'),
                  onSignedOut: () {
                    if (mounted) context.go('/');
                  },
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _error != null
                    ? Text(
                        'Status-Abfrage fehlgeschlagen: $_error',
                        style: const TextStyle(color: Colors.redAccent),
                      )
                    : _buildChip(),
              ),
            ),
          ),
          drawer: (!_setupNeeded && _isSignedIn)
              ? Drawer(
                  child: ListView(
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Text(
                          'Navigation',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Start'),
                        onTap: () => _goTo('/'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('Members'),
                        onTap: () => _goTo('/members'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock_open),
                        title: const Text('Selbsteinlass'),
                        onTap: () => _goTo('/selbsteinlass'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('Standort'),
                        onTap: () => _goTo('/standort'),
                      ),
                    ],
                  ),
                )
              : null,
          body: _setupNeeded
              ? _SetupReasonBanner(
                  state: _status?.state,
                  error: _status?.lastError,
                  child: widget.child,
                )
              : widget.child,
        );
      },
    );
  }

  Widget _buildChip() {
    final state = _status?.state;
    final String label;
    final Color color;
    switch (state) {
      case SiteConnectionState.connected:
        label = 'Verbunden';
        color = Colors.green;
      case SiteConnectionState.reconnecting:
        label = 'Wiederverbinden…';
        color = Colors.orange;
      case SiteConnectionState.needsReSetup:
        label = 'Neu einrichten!';
        color = Colors.red;
      case SiteConnectionState.connecting:
        label = 'Verbinde…';
        color = Colors.orange;
      case SiteConnectionState.failure:
        label = 'Fehler';
        color = Colors.red;
      case SiteConnectionState.noneSetup:
        label = 'Noch nicht eingerichtet';
        color = Colors.blueGrey;
      default:
        label = '—';
        color = Colors.blueGrey;
    }
    return Chip(
      avatar: Icon(Icons.circle, size: 14, color: color),
      label: Text(label, style: const TextStyle(color: Colors.black87)),
    );
  }
}

/// Shows the current setup state/reason above the setup mask (first setup
/// vs. credential loss / revoked connection).
class _SetupReasonBanner extends StatelessWidget {
  final SiteConnectionState? state;
  final String? error;
  final Widget child;

  const _SetupReasonBanner({
    required this.state,
    required this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReSetup = state == SiteConnectionState.needsReSetup;

    return Column(
      children: [
        MaterialBanner(
          content: Text(
            isReSetup
                ? 'Die Geräte-Anmeldung zur globalen Instanz ist nicht mehr '
                      'gültig — bitte erneut einrichten.'
                : 'Diese Instanz ist noch nicht mit der globalen Instanz '
                      'verbunden — bitte einrichten.',
            style: TextStyle(
              color: isReSetup ? theme.colorScheme.error : null,
            ),
          ),
          leading: Icon(
            isReSetup ? Icons.lock_reset : Icons.add_business,
          ),
          backgroundColor: isReSetup
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.surfaceContainerHighest,
          actions: [
            if (error != null)
              Tooltip(
                message: error!,
                child: const Icon(Icons.info_outline),
              ),
            const SizedBox(width: 8),
          ],
        ),
        Expanded(child: child),
      ],
    );
  }
}
