import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  Future<UserCredential?> signIn(String login, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: login, password: password);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> signUp(String login, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: login, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future resetPassword(String login) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: login);
  }
}