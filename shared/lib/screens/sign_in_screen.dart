import 'package:flutter/material.dart';

/// Backend contract for the login-only sign-in screen: verifies the
/// credentials against the instance's email IdP and REGISTERS the returned
/// session with the app's auth session manager (e.g.
/// `final success = await client.emailIdp.login(email:, password:);
/// await client.auth.updateSignedInUser(success);`).
///
/// No registration affordances by design: end-user registration lives in
/// the end-user app; admin apps must not offer sign-up (backlog item 9).
abstract interface class EmailSignInApi {
  Future<void> login({
    required final String email,
    required final String password,
  });
}

/// Hand-written email/password login form (no sign-up): used by the
/// local site admin app and the global platform admin app. On success the
/// host navigates via [onAuthenticated] (typical: `context.go('/')` — the
/// router redirect re-evaluates on the auth state change anyway).
class SignInScreen extends StatefulWidget {
  final EmailSignInApi api;

  final void Function()? onAuthenticated;

  const SignInScreen({required this.api, this.onAuthenticated, super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _signingIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _signingIn = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await widget.api.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      messenger.showSnackBar(const SnackBar(content: Text('Angemeldet.')));
      widget.onAuthenticated?.call();
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Anmelden fehlgeschlagen: $e')),
      );
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Anmelden',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Passwort',
                    prefixIcon: Icon(Icons.password),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Pflichtfeld' : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _signingIn ? null : _submit,
                  child: _signingIn
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Anmelden'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
