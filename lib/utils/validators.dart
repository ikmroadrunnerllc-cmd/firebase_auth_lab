// Return an error message, or null if the value is OK.

String? validateEmail(String? value) {
  final parts = (value ?? '').trim().split('@');
  if (parts.length != 2 ||
      parts[0].isEmpty ||
      parts[1].isEmpty ||
      !parts[1].contains('.')) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value != password) return 'Passwords do not match.';
  return null;
}

String? validateCurrentPassword(String? value) {
  if (value == null || value.isEmpty) return 'Enter your current password.';
  return null;
}
