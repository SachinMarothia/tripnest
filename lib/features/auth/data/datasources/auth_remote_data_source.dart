import 'package:firebase_auth/firebase_auth.dart';

import '../exceptions/auth_exception.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  const AuthRemoteDataSource({required this.firebaseAuth});

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    }
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    }
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'user-not-found':
        return 'No account was found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Please choose a stronger password.';

      case 'operation-not-allowed':
        return 'This sign-in method is currently unavailable.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Check your internet connection and try again.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
