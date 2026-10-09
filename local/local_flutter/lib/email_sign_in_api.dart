import 'package:itsbits_shared/screens/sign_in_screen.dart';
import 'package:local_client/local_client.dart' as lc;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Adapter for the shared login-only sign-in screen: verifies the local
/// credentials and — IMPORTANT — registers the returned session with the
/// app's auth session manager (`client.auth.updateSignedInUser`); the
/// plain endpoint call does NOT store the token itself.
class LocalEmailSignInApi implements EmailSignInApi {
  final lc.Client _client;

  LocalEmailSignInApi(this._client);

  @override
  Future<void> login({
    required final String email,
    required final String password,
  }) async {
    final success = await _client.emailIdp.login(
      email: email,
      password: password,
    );
    await _client.auth.updateSignedInUser(success);
  }
}
