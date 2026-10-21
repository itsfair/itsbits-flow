import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage_rustfs/serverpod_cloud_storage_rustfs.dart';

import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/site/global_site_connection.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/door_verify_route.dart';

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
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      // The default setup works with Serverpod Cloud without configuration. In
      // development the verification codes are logged to the console, and in
      // staging and production they are sent through the Serverpod Cloud email
      // service. If you want to use a custom provider for sending emails, use
      // `EmailIdpConfigFromPasswords`.
      ServerpodCloudEmailIdpConfig(
        appDisplayName: 'local',
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

  // Door-access verification route for the doorinterfaces (plain HTTP
  // from the LAN, no device auth in the MVP). MUST be registered before
  // the catch-all Flutter web app route.
  pod.webServer.addRoute(DoorVerifyRoute());

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

  // Start the site connection worker (no-op until the local instance is
  // enrolled at a global instance; the worker then connects on every
  // start).
  await GlobalSiteConnection.instance.start();
}

/// Resolves the RustFS endpoint (scheme/host/port of the S3 API) with
/// the override chain: `SERVERPOD_RUSTFS_ENDPOINT` env var >
/// `rustFsEndpoint` password (config/passwords.yaml) > local default.
Uri _rustFsEndpointUri(Serverpod pod) {
  pod.loadCustomPasswords([
    (envName: 'SERVERPOD_RUSTFS_ENDPOINT', alias: 'rustFsEndpoint'),
  ]);
  final endpoint = pod.getPassword('rustFsEndpoint') ?? 'http://localhost:9200';
  return Uri.parse(endpoint);
}
