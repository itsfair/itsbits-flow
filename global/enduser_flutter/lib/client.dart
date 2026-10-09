import 'dart:async';

import 'package:global_client/global_client.dart';
import 'package:itsbits_shared/profile_state.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'member_profile_api.dart';

// When you are running the app on a physical device, you need to set the
// server URL to the IP address of your computer. You can find the IP
// address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
//
// You can set the variable when running or building your app like this:
// E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`.
//
// Otherwise, the server URL is fetched from the assets/config.json file or
// defaults to http://$localhost:8080/ if not found.
final serverUrl = getServerUrl();

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app.
late final Client client;

/// Client-side APIs (the shared components are client-agnostic; the
/// adapters mapping the generated endpoints onto them live app-side).
final GlobalMemberProfileApi memberProfileApi = GlobalMemberProfileApi(
  client.memberProfile,
);

/// Holds the signed-in user's profile data for the shared widgets.
final ProfileState profileState = ProfileState(memberProfileApi);

Future<void> initializeClient() async {
  client = Client(await serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  unawaited(client.auth.initialize());
}
