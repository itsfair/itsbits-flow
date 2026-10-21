import 'dart:async';
import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage_rustfs/serverpod_cloud_storage_rustfs.dart';

import 'src/cache_busting.dart';
import 'src/auth/email_sender.dart';
import 'src/generated/protocol.dart';
import 'src/generated/serverpod.dart';
import 'src/sites/site_device_authentication.dart';
import 'src/web/routes/app_config_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server (identity
      // providers issue this type; interactive users).
      JwtConfigFromPasswords(),
      // Server-side (SAS) sessions validate our device credentials: the
      // credential the local instance obtains at enrollment is a
      // non-rotating SAS session key (`method: 'device'`, scope
      // `site-device`). Same config/pepper as the issuance in
      // SiteDeviceAuthentication (see lib/src/sites/site_device_authentication.dart).
      SiteDeviceAuthentication.config,
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password
      // authentication. Codes are logged instead of emailed in dev.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
        // Create the sparse member_profile row right at registration (the
        // profile carries the registration email; profile data gets
        // completed later by the memberProfile endpoints). Guarantees that
        // memberships (which link the profile) can always resolve a person.
        onAfterAccountCreated: _createMemberProfileRow,
      ),
    ],
  );

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under /.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );

    pod.webServer.addRoute(
      defaultRoute,
      '/**',
    );
  }

  // File storage: RustFS (S3-compatible) as the 'public' storage,
  // replacing the database-backed default. Credentials/bucket come from
  // the adapter (SERVERPOD_RUSTFS_* env vars, defaults: rustfsadmin /
  // rustfsadmin_secret). The endpoint is stage-specific, so it travels
  // via the `rustFsEndpoint` password (env override:
  // SERVERPOD_RUSTFS_ENDPOINT; value in config/passwords.yaml — dev uses
  // the LAN IP for tests from real devices). Never set `publicHost` on
  // the adapter.
  // The bucket is PRIVATE: reads are presigned (ImageUrlSigner), writes
  // run with the SigV4 credentials. `public: false` is intentional —
  // the storageId keeps its historic name.
  pod.addCloudStorage(
    RustFsCloudStorage(
      serverpod: pod,
      storageId: 'public',
      public: false,
      bucket: 'itsbits-flow',
      baseUri: _rustFsEndpointUri(pod),
    ),
  );

  // Start the server.
  await pod.start();
}

/// Resolves the RustFS endpoint (scheme/host/port of the S3 API) with
/// the override chain: `SERVERPOD_RUSTFS_ENDPOINT` env var >
/// `rustFsEndpoint` password (config/passwords.yaml) > local default.
Uri _rustFsEndpointUri(Serverpod pod) {
  pod.loadCustomPasswords([
    (envName: 'SERVERPOD_RUSTFS_ENDPOINT', alias: 'rustFsEndpoint'),
  ]);
  final endpoint = pod.getPassword('rustFsEndpoint') ?? 'http://localhost:9000';
  return Uri.parse(endpoint);
}

final _emailSender = EmailSender(appDisplayName: 'itsbits-flow');

Future<void> _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  return _emailSender.sendRegistrationCode(
    session,
    email: email,
    verificationCode: verificationCode,
  );
}

Future<void> _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  return _emailSender.sendPasswordResetCode(
    session,
    email: email,
    verificationCode: verificationCode,
  );
}

/// Creates the sparse `member_profile` row right after the account was
/// created (registration). The row carries the registration email; the
/// profile data (names, birthday, image) gets completed later via the
/// `memberProfile` endpoints. Memberships link this profile, so a row must
/// exist before a person can be assigned to a site.
FutureOr<void> _createMemberProfileRow(
  Session session, {
  required String email,
  required UuidValue authUserId,
  required UuidValue emailAccountId,
  required Transaction? transaction,
}) async {
  await MemberProfile.db.insertRow(
    session,
    MemberProfile(
      authUserId: authUserId,
      email: email.toLowerCase(),
    ),
    transaction: transaction,
  );
}
