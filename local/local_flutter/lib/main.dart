import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'layout.dart';

import 'screens/home.dart';
import 'screens/member_detail.dart';
import 'screens/members.dart';
import 'screens/profile.dart';
import 'screens/selbsteinlass.dart';
import 'screens/site_setup.dart';
import 'screens/sign_in.dart';
import 'screens/standort.dart';

/// Local mirror of the device-connection setup state: the shell polls
/// `siteSetup.connectionStatus` and updates this notifier, so the GoRouter
/// redirect re-evaluates after enrollments/connectivity changes.
final ValueNotifier<SiteConnectionState> connectionStateNotifier =
    ValueNotifier(SiteConnectionState.noneSetup);

/// Redirect rules (see local AGENTS.md):
/// - `noneSetup` / `needsReSetup`: the SETUP masking is forced for every
///   route — the drawer and the login entry are hidden app-side.
/// - enrolled + not signed in: always on `/sign-in`.
/// - signed in: free navigation.
final Set<SiteConnectionState> kSetupStates = {
  SiteConnectionState.noneSetup,
  SiteConnectionState.needsReSetup,
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeClient();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    refreshListenable: Listenable.merge([
      client.auth.authInfoListenable,
      connectionStateNotifier,
      profileState,
    ]),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final setupNeeded = kSetupStates.contains(connectionStateNotifier.value);
      final signedIn = client.auth.isAuthenticated;

      // Setup mask is the whole app while the connection is not usable.
      if (setupNeeded) {
        return null;
      }

      // Enrolled: signed-out users live on the login screen.
      if (!signedIn) {
        return location == '/sign-in' ? null : '/sign-in';
      }

      // Signed in: the login screen is no longer needed.
      if (location == '/sign-in') {
        return '/';
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Layout(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/members',
            builder: (context, state) => const MembersScreen(),
          ),
          GoRoute(
            path: '/members/:globalAuthUserId',
            builder: (context, state) => MemberDetailScreen(
              globalAuthUserId: state.pathParameters['globalAuthUserId']!,
            ),
          ),
          GoRoute(
            path: '/selbsteinlass',
            builder: (context, state) => const SelbsteinlassScreen(),
          ),
          GoRoute(
            path: '/standort',
            builder: (context, state) => const StandortScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/setup',
            builder: (context, state) => const SiteSetupScreen(),
          ),
          GoRoute(
            path: '/sign-in',
            builder: (context, state) => const LocalSignInScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_onAuthChanged);
    // Handle a restored session from a previous app run.
    _onAuthChanged();
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (client.auth.isAuthenticated) {
      profileState.load();
    } else {
      profileState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Site Admin UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}
