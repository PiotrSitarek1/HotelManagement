import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:hotel_manager/models/user_model.dart';

class UserService {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');

  Future<void> addUser(User user) async {
    Map<String, dynamic> userMap = user.toMap();
    await _userRef.push().set(userMap);
  }

  Future<void> fetchAllUsers() async {
    DatabaseEvent databaseEvent = await _userRef.once();
    if (databaseEvent.snapshot.value != null &&
        databaseEvent.snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> usersMap =
          databaseEvent.snapshot.value as Map<dynamic, dynamic>;
      usersMap.forEach((key, value) {
        log('User ID: $key, User Data: $value');
      });
    }
  }

  Future<User?> getUserById(String userId) async {
    DataSnapshot snapshot = await _userRef.child(userId).once() as DataSnapshot;
    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> userMap = snapshot.value as Map<dynamic, dynamic>;
      return User.fromMap(userMap.cast<String, dynamic>());
    }

    return null;
  }

  Future<void> updateUser(String userId, User updatedUser) async {
    Map<String, dynamic> userMap = updatedUser.toMap();
    await _userRef.child(userId).update(userMap);
  }

  Future<void> deleteUser(String userId) async {
    await _userRef.child(userId).remove();
  }
}
