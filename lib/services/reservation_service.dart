import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/utils/utils.dart';

class ReservationServices {
  final DatabaseReference _reservationRef =
      FirebaseDatabase.instance.ref().child('reservations');

  Future<void> addReservation(Reservation reservation) async {
    Map<String, dynamic> reservationMap = reservation.toMap();
    DatabaseReference newChild = _reservationRef.push();
    await newChild.set(reservationMap);
    showToast("dodano rezerewacje");
  }

  Future<Reservation?> getReservationByUID(String rID) async {
    DataSnapshot snapshot = await _reservationRef.child(rID).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> reservationData = json.decode(json.encode(snapshot.value));
    return Reservation.fromMap(reservationData);
  }

  Future<Map<String, dynamic>?> getReservationFromSingleHotel(String hotelID) async {
    DataSnapshot snapshot = await _reservationRef.get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> reservationData = json.decode(json.encode(snapshot.value));
    Map<String, dynamic> reservationsFromSingleHotel = {};
    reservationData.forEach((key, value) {
      if(value['hotelId'] == hotelID){
        reservationsFromSingleHotel[key] = value;
      }
    });
    if(reservationsFromSingleHotel.isNotEmpty){
      return reservationsFromSingleHotel;
    }
    return null;
  }

  Future<void> cancelReservation(String reservationId) async {
    //todo: what happens when cannot cancel reservation, should it be checked here?
    await _reservationRef.child(reservationId).remove();
  }

  Future<void> deleteReservation(String reservationId) async {
    await _reservationRef.child(reservationId).remove();
  }

  Future<void> updateReservation(String reservationId, Reservation reservation) async {
    Map<String, dynamic> userMap = reservation.toMap();
    await _reservationRef.child(reservationId).update(userMap);
  }
}