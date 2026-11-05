# Firebase Auth Lab

CSC 4360 In-Class Activity #13

## Overview

A small Flutter app for Android that uses Firebase email/password login.
You can register, sign in, see your email, change your password and sign out.

How the code is organized:

| Folder          | What's inside                                          |
|-----------------|--------------------------------------------------------|
| `lib/services`  | `AuthService`, the only file that calls Firebase Auth  |
| `lib/screens`   | `AuthGate` (picks the screen), sign-in, and profile    |
| `lib/utils`     | Form validators and friendly error messages            |
| `lib/widgets`   | A reusable text field and button                       |

## Required Firebase configuration

1. Open the Firebase Console (console.firebase.google.com) and create a project.
2. Go to **Authentication → Sign-in method** and turn on **Email/Password**.
3. Run `flutterfire configure` (below). It connects this app to your project.

`lib/firebase_options.dart` is **generated** and is not in this repo (it is in
`.gitignore`). Every machine must make its own by running
`flutterfire configure --platforms=android`.

## Setup commands

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
flutter pub get
flutterfire configure --platforms=android
```

Check that `lib/firebase_options.dart` now has real values and the terminal
showed no errors.

## Run and test

```bash
flutter run                    # run on an emulator or phone
flutter analyze                # check the code
flutter build apk --release    # make a release APK
```

The APK ends up at `build/app/outputs/flutter-apk/app-release.apk`.

### Test cases

Main path:

1. Register a new account.
2. Check the profile shows the right email.
3. Sign out.
4. Sign in again.
5. Change the password.
6. Sign out.
7. Sign in with the **new** password. It should work.
8. Sign out, then try the **old** password. It should fail.

Edge cases:

| Test                               | Expected                                                  |
|------------------------------------|-----------------------------------------------------------|
| Email `bob@site` or `bob`          | "Enter a valid email address."                            |
| 5-character password `abcde`       | "Password must be at least 6 characters."                 |
| Wrong password                     | "Email or password is incorrect." (or "Incorrect password.") |
| Close and reopen app while signed in | Goes straight to the profile screen (session restored)  |

## Implemented features

- Register, sign in and sign out with email and password
- Form checks run before anything is sent to Firebase
- Friendly error messages, never raw Firebase errors
- Buttons turn off and show a spinner while waiting
- Change password. If Firebase asks you to sign in again, the app uses your
  current password to do that, then retries once.
- Remembers you're signed in after the app restarts

## Known limitations

- Android only.
- No "forgot password" or email verification.
- The current password is only checked if Firebase asks for re-login.
  If you signed in recently, Firebase changes the password without it.
- To see the `requires-recent-login` path you need an account that has been
  signed in for a while (about 5+ minutes).
- Newer Firebase projects return `invalid-credential` instead of
  `user-not-found` / `wrong-password` (email enumeration protection).
