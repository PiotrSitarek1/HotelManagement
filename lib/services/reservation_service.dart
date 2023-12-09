import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/utils/utils.dart';

import '../screens/user_flow/reservation_placeholder.dart';

class ReservationServices {
  final DatabaseReference _reservationRef =
      FirebaseDatabase.instance.ref().child('reservations');
  final DatabaseReference _hotelRef =
  FirebaseDatabase.instance.ref().child('hotel');

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

  Future<Map<String, Reservation>?> getReservationFromSingleHotel(
      String hotelID) async {
    Query query = _reservationRef.orderByChild('hotelId').equalTo(hotelID);
    DataSnapshot snapshot = await query.get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> reservationsData =
        json.decode(json.encode(snapshot.value));
    Map<String, Reservation> reservations = {};
    reservationsData.forEach((key, value) {
      reservations[key] = Reservation.fromMap(value);
    });
    return reservations;
  }

  Future<Map<String, Reservation>?> getSpecificReservationsFromSingleHotel(
      String hotelID, String statusValue) async {
    Query query = _reservationRef.orderByChild('hotelId').equalTo(hotelID);
    DataSnapshot snapshot = await query.get();
    if (snapshot.value == null) return null;

    Map<String, dynamic> reservationsData =
    json.decode(json.encode(snapshot.value));

    Map<String, Reservation> reservations = {};

    reservationsData.forEach((key, value) {
      Reservation reservation = Reservation.fromMap(value);
      if (reservation.status == statusValue) {
        reservations[key] = reservation;
      }
    });

    return reservations;
  }

  Future<Map<String, dynamic>?> getReservationForUser(String uID) async {
    DataSnapshot snapshot = await _reservationRef.get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> reservationData = json.decode(json.encode(snapshot.value));
    Map<String, dynamic> reservationsFromSingleHotel = {};
    reservationData.forEach((key, value) {
      if(value['userId'] == uID){
        reservationsFromSingleHotel[key] = value;
      }
    });
    if(reservationsFromSingleHotel.isNotEmpty){
      return reservationsFromSingleHotel;
    }
    return null;
  }


  Future<List<ReservationPlaceholder>?> getBasicHotelInformationForUser(String uID) async {
    DataSnapshot snapshot = await _reservationRef.get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> reservationData = json.decode(json.encode(snapshot.value));

    List<ReservationPlaceholder> reservationsFromSingleHotel = [];
    await Future.forEach(reservationData.entries, (MapEntry<dynamic, dynamic> entry) async {
      if(entry.value['userId'] == uID){
        DataSnapshot hotelSnapshot =  await _hotelRef.child(entry.value['hotelId']).get();
        var value2 = hotelSnapshot.value;
        if(value2 is Map) {

          String address = value2['address'];
          String name = value2['name'];

          String image = value2['imageUrl'];
          String date = entry.value['checkInDate'];
          String dateEnd = entry.value['checkOutDate'];

          reservationsFromSingleHotel.add(ReservationPlaceholder(hotelname: name, adress: address, date:date, dateEnd: dateEnd, imageUrl: image));

        }
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

  Future<String> updateReservationStatus(
      String reservationId, String status) async {
    Map<String, dynamic> updateFields = {"status": status};
    await _reservationRef.child(reservationId).update(updateFields);
    return "SUCCESS";
  }
}