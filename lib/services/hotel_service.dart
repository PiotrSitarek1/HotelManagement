import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import '../models/hotel_model.dart';


class HotelService {
  final DatabaseReference _hotelRef =
  FirebaseDatabase.instance.ref().child('hotel');

  Future<String?> addHotel(Hotel hotel) async {
    Map<String, dynamic> hotelMap = hotel.toMap();
    DatabaseReference newHotelRef = _hotelRef.push();
    await newHotelRef.set(hotelMap);
    return newHotelRef.key;
  }

  Future<void> fetchAllHotels() async {
    DatabaseEvent databaseEvent = await _hotelRef.once();
    if (databaseEvent.snapshot.value != null &&
        databaseEvent.snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> hotelsMap =
      databaseEvent.snapshot.value as Map<dynamic, dynamic>;
      hotelsMap.forEach((key, value) {
        log('hotel ID: $key, hotel Data: $value');
      });
    }
  }

  Future<Hotel?> getHotelById(String hotelId) async {
    DataSnapshot snapshot = await _hotelRef.child(hotelId).once() as DataSnapshot;
    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> hotelMap = snapshot.value as Map<dynamic, dynamic>;
      return Hotel.fromMap(hotelMap.cast<String, dynamic>());
    }

    return null;
  }

  Future<void> updateHotel(String hotelId, Hotel updatedHotel) async {
    Map<String, dynamic> hotelMap = updatedHotel.toMap();
    await _hotelRef.child(hotelId).update(hotelMap);
  }

  Future<void> deleteHotel(String hotelId) async {
    await _hotelRef.child(hotelId).remove();
  }

  Future<void> updateHotelField(
      String hotelId, String fieldToUpdate, dynamic newValue) async {
    final updateData = {fieldToUpdate: newValue};
    try {
      await _hotelRef.child(hotelId).update(updateData);
      print("$fieldToUpdate updated successfully.");
    } catch (error) {
      print("Failed to update $fieldToUpdate: $error");
    }
  }
}
