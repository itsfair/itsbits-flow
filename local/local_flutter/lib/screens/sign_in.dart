import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/screens/sign_in_screen.dart';

import '../client.dart';
import '../email_sign_in_api.dart';

/// Login screen of the site admin app — the shared login-only form (no
/// sign-up; local accounts are created by enrollment only). The adapter
/// registers the login session with the auth session manager, after which
/// the router redirect (auth listener) lands on the app.
class LocalSignInScreen extends StatelessWidget {
  const LocalSignInScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return SignInScreen(
      api: LocalEmailSignInApi(client),
      onAuthenticated: () {
        if (context.mounted) context.go('/');
      },
    );
  }
}
