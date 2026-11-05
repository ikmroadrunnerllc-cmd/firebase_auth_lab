import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/auth_error_messages.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSigningOut = false;
  bool _isUpdating = false;
  String? _error;
  String? _success;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    await widget.authService.signOut();
    // AuthGate goes back to the sign-in screen for us.
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUpdating = true;
      _error = null;
      _success = null;
    });

    try {
      await widget.authService.updatePassword(
        _currentController.text,
        _newController.text,
      );
      _success = 'Password updated!';
      _formKey.currentState!.reset(); // clears the fields
    } on FirebaseAuthException catch (e) {
      _error = messageForAuthError(e);
    }

    setState(() => _isUpdating = false);
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.authService.currentUser?.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: ListTile(
              title: const Text('Signed in as'),
              subtitle: Text(email),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Sign Out',
            isLoading: _isSigningOut,
            onPressed: _signOut,
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: const Text('Change password'),
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Current password',
                      controller: _currentController,
                      obscure: true,
                      validator: validateCurrentPassword,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'New password',
                      controller: _newController,
                      obscure: true,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Confirm new password',
                      controller: _confirmController,
                      obscure: true,
                      validator: (value) =>
                          validateConfirmPassword(value, _newController.text),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Update Password',
                      isLoading: _isUpdating,
                      onPressed: _changePassword,
                    ),
                    const SizedBox(height: 16),
                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    if (_success != null)
                      Text(_success!, style: const TextStyle(color: Colors.green)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
