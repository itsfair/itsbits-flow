import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:itsbits_shared/screens/profile_screen.dart';

import 'client.dart';
import 'layout.dart';

import 'screens/sign_in.dart';
import 'screens/forbidden.dart';
import 'screens/sites.dart';
import 'screens/site_detail.dart';
import 'screens/members.dart';
import 'screens/member_detail.dart';

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
    refreshListenable: client.auth.authInfoListenable,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (!client.auth.isAuthenticated && location != '/sign-in') {
        return '/sign-in';
      } else if (client.auth.isAuthenticated &&
          client.auth.authInfo?.scopeNames.contains('global-admin') != true) {
        return '/forbidden';
      } else {
        return null;
      }
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Layout(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            redirect: (context, state) => '/members',
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(
              api: memberProfileApi,
              profileState: profileState,
            ),
          ),
          GoRoute(
            path: '/sign-in',
            builder: (context, state) => SignIn(),
          ),
          GoRoute(
            path: '/forbidden',
            builder: (context, state) => const Forbidden(),
          ),
          GoRoute(
            path: '/members',
            builder: (context, state) => const MembersScreen(),
          ),
          GoRoute(
            path: '/members/:authUserId',
            builder: (context, state) => MemberDetailScreen(
              authUserId: state.pathParameters['authUserId']!,
            ),
          ),
          GoRoute(
            path: '/sites',
            builder: (context, state) => const SitesScreen(),
          ),
          GoRoute(
            path: '/sites/:siteId',
            builder: (context, state) => SiteDetailScreen(
              siteId: int.parse(state.pathParameters['siteId']!),
            ),
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
      title: 'Global Admin UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}
