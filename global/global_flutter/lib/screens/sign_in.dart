import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/screens/sign_in_screen.dart';

import '../client.dart';
import '../email_sign_in_api.dart';

/// Login screen of the platform admin app — the shared login-only form
/// (no sign-up affordances; end-user registration must not be possible
/// in this app, backlog item 9). The adapter registers the login session
/// with the auth session manager before the router redirect runs.
class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(final BuildContext context) {
    return SignInScreen(
      api: GlobalEmailSignInApi(client),
      onAuthenticated: () {
        if (context.mounted) context.go('/');
      },
    );
  }
}
