import 'package:firebase_auth/firebase_auth.dart';

/// Turns a Firebase error code into a message a normal person can read.
/// We never show e.message or e.toString() to the user.
String messageForAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return "That email address isn't valid.";
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'user-not-found':
      return 'No account found with that email.';
    case 'wrong-password':
      return 'Incorrect password. Try again.';
    case 'invalid-credential':
      return 'Email or password is incorrect.';
    case 'email-already-in-use':
      return 'An account already exists for that email. Sign in instead.';
    case 'weak-password':
      return 'Choose a stronger password (at least 6 characters).';
    case 'too-many-requests':
      return 'Too many attempts. Wait a moment and try again.';
    case 'requires-recent-login':
      return 'Please confirm your current password to continue.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
