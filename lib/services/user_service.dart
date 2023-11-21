import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:hotel_manager/models/user_model.dart';

class UserService {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');

  Future<void> addUser(String uID,UserDb user) async {
    Map<String, dynamic> userMap = user.toMap();
    await _userRef.child(uID).set(userMap);
  }

  Future<UserDb?> getUserByUID(String uID) async {
    DataSnapshot snapshot = await _userRef.child(uID).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    return UserDb.fromMap(userData);
  }

  Future<String?> getHotelByUserUID(String uID) async {
    UserDb? userDb = await getUserByUID(uID);
    if(userDb != null) {
      return userDb.hotelId;
    } else {
      return "USER_NOT_FOUND";
    }
  }

  Future<String> updateUserFields(String userId, String firstname,
      String lastname, String username, String imageUrl) async {
    try {
      Map<String, dynamic> updateFields = {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "imageUrl": imageUrl,
      };
      await _userRef.child(userId).update(updateFields);
      return "SUCCESS";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deleteUser(String userId) async {
    await _userRef.child(userId).remove();
  }
}
