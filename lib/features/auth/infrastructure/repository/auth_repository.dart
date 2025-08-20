import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> login(String email, String password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}
