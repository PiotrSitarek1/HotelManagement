import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:hotel_manager/models/service_model.dart';
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

  Future<List<Hotel>?> getAllHotels() async {
    DataSnapshot snapshot = await _hotelRef.get();
    if (snapshot.value == null) return null;
    List<Hotel> hotelsList = [];
    Map<String, dynamic> hotelsData = json.decode(json.encode(snapshot.value));
    hotelsData.forEach((key, value) {
      Hotel hotel = Hotel.fromMap(value);
      hotelsList.add(hotel);
    });
    return hotelsList;
  }

  Future<Hotel?> getHotelById(String hotelId) async {
    DataSnapshot snapshot = await _hotelRef.child(hotelId).get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> hotelData = json.decode(json.encode(snapshot.value));
    return Hotel.fromMap(hotelData);
  }

  Future<String> updateHotel(String hotelId, Hotel updatedHotel) async {
    try {
      Map<String, dynamic> hotelMap = updatedHotel.toMap();
      await _hotelRef.child(hotelId).update(hotelMap);
      return "SUCCESS";
    }catch(e){
      return e.toString();
    }
  }

  Future<String> updateHotelFields(
      String hotelId,
      String newName,
      String newAddress,
      String newEmail,
      String newPhone,
      String uID,
      String imageUrl) async {
    try {
      Map<String, dynamic> updateFields = {
        "name": newName,
        "address": newAddress,
        "email": newEmail,
        "phoneNumber": newPhone,
        "supervisorId": uID,
        "imageUrl": imageUrl,
      };

      await _hotelRef.child(hotelId).update(updateFields);

      return "SUCCESS";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deleteHotel(String hotelId) async {
    await _hotelRef.child(hotelId).remove();
  }

  Future<List<Service>?> getServicesByHotelId(String hotelId) async {
    DataSnapshot snapshot =
        await _hotelRef.child(hotelId).child('services').get();
    List<Service> servicesList = [];
    Map<String, dynamic> servicesData =
        json.decode(json.encode(snapshot.value));
    servicesData.forEach((key, value) {
      Service service = Service.fromMap(value);
      servicesList.add(service);
    });
    return servicesList;
  }

  Future<Service?> getServiceByHotelIdAndServiceId(
      String hotelId, String serviceId) async {
    DataSnapshot snapshot =
        await _hotelRef.child(hotelId).child('services').child(serviceId).get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> serviceData = json.decode(json.encode(snapshot.value));
    return Service.fromMap(serviceData);
  }

  Future<Service?> getServiceByHotelIdAndName(
      String hotelId, String serviceName) async {
    Query query = _hotelRef
        .child(hotelId)
        .child('services')
        .orderByChild('name')
        .equalTo(serviceName);
    DataSnapshot snapshot = await query.get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> serviceData = json.decode(json.encode(snapshot.value));
    String serviceId = serviceData.keys.first;
    return Service.fromMap(serviceData[serviceId]);
  }

  Future<String?> getServiceKeyByHotelIdAndName(
      String hotelId, String serviceName) async {
    Query query = _hotelRef
        .child(hotelId)
        .child('services')
        .orderByChild('name')
        .equalTo(serviceName);
    DataSnapshot snapshot = await query.get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> serviceData = json.decode(json.encode(snapshot.value));
    return serviceData.keys.first;
  }
  Future<String?> addService(
      String hotelId, Service newService) async {
    Map<String, dynamic> serviceMap = newService.toMap();
    DatabaseReference newServiceRef =
        _hotelRef.child(hotelId).child('services').push();
    await newServiceRef.set(serviceMap);
    return newServiceRef.key;
  }

  Future<void> updateService(
      String hotelId, String serviceId, Service updatedService) async {
    DatabaseReference servicesRef =
        _hotelRef.child(hotelId).child('services').child(serviceId);
    await servicesRef.update(updatedService.toMap());
  }
}
