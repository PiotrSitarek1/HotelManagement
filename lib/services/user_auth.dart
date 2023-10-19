import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:hotel_manager/utils/Roles.dart';
import 'package:hotel_manager/models/user_model.dart' as model;

class UserAuth {
  final UserService _userService = UserService();

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
      model.User model_user = model.User(login, Role.user, 0);
      _userService.addUser(model_user);
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