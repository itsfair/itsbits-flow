import 'package:global_client/global_client.dart' as gc;
import 'package:itsbits_shared/screens/sign_in_screen.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Adapter for the shared login-only sign-in screen (platform admin app):
/// verifies the global credentials and registers the returned session
/// with the auth session manager (the plain endpoint call does NOT store
/// the token itself).
class GlobalEmailSignInApi implements EmailSignInApi {
  final gc.Client _client;

  GlobalEmailSignInApi(this._client);

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
