import 'dart:convert';

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

  Future<List<Room>?> getRoomsByHotelId(String hotelId) async {
    Query query = _roomRef.orderByChild('hotelId').equalTo(hotelId);
    DataSnapshot snapshot = await query.get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> roomData = json.decode(json.encode(snapshot.value));
    List<Room> rooms = [];
    roomData.forEach((key, value) {
      rooms.add(Room.fromMap(value));
    });
    return rooms;
  }

  Future<Room?> getRoomByNumber(int roomNum) async {
    Query query = _roomRef.orderByChild('number').equalTo(roomNum);
    DataSnapshot snapshot = await query.get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> roomData = json.decode(json.encode(snapshot.value));
    String roomId = roomData.keys.first;
    return Room.fromMap(roomData[roomId]);
  }

  Future<String?> getRoomKeyByNumber(int roomNum) async {
    Query query = _roomRef.orderByChild('number').equalTo(roomNum);
    DataSnapshot snapshot = await query.get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> roomData = json.decode(json.encode(snapshot.value));
    return roomData.keys.first;
  }
}
