import 'package:hotel_manager/utils/Roles.dart';

class UserDb {
  final String username;
  final String firstname;
  final String lastname;
  final Role role;
  final String hotelId;
  final bool activated;
  late final String imageUrl;

  UserDb(
      {required this.username,
      required this.firstname,
      required this.lastname,
      required this.role,
      required this.hotelId,
      required this.activated,
      String? imageUrl})
      : imageUrl = imageUrl ?? '';

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'role': role.toString().split('.').last,
      'hotelId': hotelId,
      'activated': activated,
      'imageUrl': imageUrl,
    };
  }

  factory UserDb.fromMap(Map<String, dynamic> map) {
    return UserDb(
        username: map['username'] ?? '',
        firstname: map['firstname'] ?? '',
        lastname: map['lastname'] ?? '',
        role: map['role'] != null
            ? Role.values
                .firstWhere((role) => role.toString() == 'Role.${map['role']}')
            : Role.user,
        hotelId: map['hotelId'] ?? '',
        activated: map['activated'] ?? '',
        imageUrl: map['imageUrl'] ?? '');
  }
}
