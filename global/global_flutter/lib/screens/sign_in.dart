import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SignInWidget(
        client: client,
        emailSignInWidget: EmailSignInWidget(
          client: client,
          startScreen: EmailFlowScreen.login,
          onAuthenticated: () {
            context.go('/');
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          },
        ),
      ),
    );
  }
}
