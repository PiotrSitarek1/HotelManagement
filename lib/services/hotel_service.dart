import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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

  Future<String?> getServiceByHotelIdAndName(
      String hotelId, String serviceName) async {
    Hotel? hotel = await getHotelById(hotelId);
    if (hotel != null) {
      int index = hotel.services.indexWhere(
        (service) => service.name == serviceName,
      );
      return index.toString();
    } else {
      return null;
    }
  }

  Future<String?> addService(
      String hotelId, Service newService) async {
    Map<String, dynamic> serviceMap = newService.toMap();
    DatabaseReference newServiceRef =
        _hotelRef.child(hotelId).child('services').push();
    await newServiceRef.set(serviceMap);
    return newServiceRef.key;
  }

  Future<void> updateServiceInFirebase(
      String hotelId, String serviceId, Service updatedService) async {
    DatabaseReference servicesRef =
        _hotelRef.child(hotelId).child('services').child(serviceId);
    await servicesRef.update(updatedService.toMap());
  }
}
