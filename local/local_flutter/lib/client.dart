import 'dart:async';

import 'package:itsbits_shared/profile_state.dart';
import 'package:local_client/local_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Re-export the generated client and models so app code can import this
// file as single dependency.
export 'package:local_client/local_client.dart';

import 'member_profile_api.dart';

// When you are running the app on a physical device, you need to set the
// server URL to the IP address of your computer. You can find the IP
// address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
//
// You can set the variable when running or building your app like this:
// E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`.
//
// Otherwise, the server URL is fetched from the assets/config.json file or
// defaults to http://$localhost:8180/ if not found.
final serverUrl = getServerUrl();

/// Sets up a local client object that can be used to talk to the server
/// from anywhere in our app (generated from `local_server`).
late final Client client;

/// The signed-in person's mirrored profile data for the shared widgets.
final LocalMemberProfileApi memberProfileApi = LocalMemberProfileApi(client);

/// Shared profile state (read-only mode in this app: profiles are edited
/// globally only; the shared ProfileScreen runs with editing disabled).
final ProfileState profileState = ProfileState(memberProfileApi);

Future<void> initializeClient() async {
  client = Client(await serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  unawaited(client.auth.initialize());
}
