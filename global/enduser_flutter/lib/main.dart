import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/screens/profile_screen.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'layout.dart';

import 'screens/ble_test.dart';
import 'screens/home.dart';
import 'screens/qr_reader.dart';
import 'screens/sign_in.dart';

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
    // Re-evaluate the redirect whenever auth or profile data changes.
    refreshListenable: Listenable.merge([
      client.auth.authInfoListenable,
      profileState,
    ]),
    redirect: (context, state) {
      final location = state.matchedLocation;

      // While not signed in, keep users away from the profile page.
      if (!client.auth.isAuthenticated) {
        return location == '/profile' ? '/' : null;
      }

      // Force new users to complete their mandatory profile fields first.
      final mustCompleteProfile =
          location != '/profile' &&
          profileState.loaded &&
          !profileState.isComplete;
      return mustCompleteProfile ? '/profile' : null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Layout(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) => HomePage(),
          ),
          GoRoute(
            path: '/qr-reader',
            builder: (context, state) => QRReader(),
          ),
          GoRoute(
            path: '/sign-in',
            builder: (context, state) => const SignIn(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(
              api: memberProfileApi,
              profileState: profileState,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/ble-test',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BleTestScreen(
            remoteId: extra?['remoteId'] as String,
            token: extra?['token'] as String?,
          );
        },
      ),
    ],
  );

  void _onAuthChanged() {
    if (client.auth.isAuthenticated) {
      profileState.load();
    } else {
      profileState.reset();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'itsbits-flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}
