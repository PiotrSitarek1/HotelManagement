import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:hotel_manager/models/room_model.dart';

class RoomService {
  final DatabaseReference _roomRef =
      FirebaseDatabase.instance.ref().child('room');

  Future<String?> addRoom(Room room) async {
    Map<String, dynamic> roomMap = room.toMap();
    DatabaseReference newRoomRef = _roomRef.push();
    await newRoomRef.set(roomMap);
    return newRoomRef.key;
  }

  Future<Room?> getRoomById(String roomId) async {
    DataSnapshot snapshot = await _roomRef.child(roomId).get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> roomData = json.decode(json.encode(snapshot.value));
    return Room.fromMap(roomData);
  }

  Future<String> updateRoom(String roomId, Room updatedRoom) async {
    try {
      Map<String, dynamic> roomMap = updatedRoom.toMap();
      await _roomRef.child(roomId).update(roomMap);
      return "SUCCESS";
    } catch (e) {
      return e.toString();
    }
  }

  // TODO: TO BE TESTED
  Future<List<Room>?> getRoomsByHotelId(String hotelId) async {
    try {
      DataSnapshot snapshot =
          await _roomRef.orderByChild("hotelId").equalTo(hotelId).get();
      if (snapshot.value == null) return null;
      Map<String, dynamic> roomsData = json.decode(json.encode(snapshot.value));

      List<Room> rooms = [];

      roomsData.forEach((key, value) {
        Map<String, dynamic> roomData = value;
        rooms.add(Room.fromMap(roomData));
      });

      return rooms;
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<Room?> getRoomByNumber(String roomNum) async {
    try {
      DataSnapshot snapshot =
          await _roomRef.orderByChild("number").equalTo(roomNum).get();
      if (snapshot.value == null) return null;
      Map<String, dynamic> roomsData = json.decode(json.encode(snapshot.value));
      String roomId = roomsData.keys.first;
      return Room.fromMap(roomsData[roomId]);
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<String?> getRoomKeyByNumber(String roomNum) async {
    try {
      DataSnapshot snapshot =
      await _roomRef.orderByChild("number").equalTo(roomNum).get();
      if (snapshot.value == null) return null;
      Map<String, dynamic> roomsData = json.decode(json.encode(snapshot.value));
      return roomsData.keys.first;
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }
}
