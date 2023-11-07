import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:hotel_manager/models/user_model.dart';

class UserService {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');

  Future<void> addUser(UserDb user) async {
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

  Future<UserDb?> getUserByUID(String uID) async {
    Query query = _userRef.orderByChild("uID").equalTo(uID);
    DataSnapshot event = await query.get();
    Map<String, dynamic> userData = json.decode(json.encode(event.children.first.value));
    return UserDb.fromMap(userData);
  }

  Future<void> updateUser(String userId, UserDb updatedUser) async {
    Map<String, dynamic> userMap = updatedUser.toMap();
    await _userRef.child(userId).update(userMap);
  }

  Future<void> deleteUser(String userId) async {
    await _userRef.child(userId).remove();
  }
}
