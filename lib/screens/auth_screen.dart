import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/auth_error_messages.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

enum AuthMode { signIn, register }

class AuthScreen extends StatefulWidget {
  final AuthService authService;

  const AuthScreen({super.key, required this.authService});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  AuthMode _mode = AuthMode.signIn;
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (_mode == AuthMode.signIn) {
        await widget.authService.signIn(email, password);
      } else {
        await widget.authService.register(email, password);
      }
      // On success AuthGate shows the profile screen for us.
    } on FirebaseAuthException catch (e) {
      _error = messageForAuthError(e);
    }

    // After a successful login this screen is gone, so check first.
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == AuthMode.signIn ? AuthMode.register : AuthMode.signIn;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSignIn = _mode == AuthMode.signIn;

    return Scaffold(
      appBar: AppBar(title: Text(isSignIn ? 'Sign In' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              AppTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Password',
                controller: _passwordController,
                obscure: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 16),
              if (!isSignIn)
                AppTextField(
                  label: 'Confirm password',
                  controller: _confirmController,
                  obscure: true,
                  validator: (value) =>
                      validateConfirmPassword(value, _passwordController.text),
                ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: isSignIn ? 'Sign In' : 'Register',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              TextButton(
                onPressed: _isLoading ? null : _toggleMode,
                child: Text(isSignIn ? 'Need an account? Register' : 'Have an account? Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
