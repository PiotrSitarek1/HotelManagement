import 'package:hotel_manager/models/service_model.dart';

class Hotel {
  final String name;
  final String address;
  late final String email;
  late final String phoneNumber;
  late final String imageUrl;
  late final String supervisorId;
  late final List<Service> services;

  Hotel({
    required this.name,
    required this.address,
    String? email,
    String? phoneNumber,
    String? imageUrl,
    String? supervisorId,
    List<Service>? services,
  })  : email = email ?? '',
        phoneNumber = phoneNumber ?? '',
        supervisorId = supervisorId ?? '',
        imageUrl = imageUrl ?? '',
        services = services ?? [];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'supervisorId': supervisorId,
      'services': services,
    };
  }

  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      name: map['name'],
      address: map['address'],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      supervisorId: map['supervisorId'] ?? '',
      services: (map['services'] != null && map['services'] is Iterable)
          ? List<Service>.from(map['services'])
          : [],
    );
  }
}
