import 'package:hotel_manager/utils/Roles.dart';

class UserDb {
  final String username;
  final String firstname;
  final String lastname;
  final Role role;
  final String hotelId;

  UserDb(this.username, this.firstname, this.lastname, this.role,
      this.hotelId);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'role': role.toString().split('.').last,
      'hotelId': hotelId,
    };
  }

  factory UserDb.fromMap(Map<String, dynamic> map) {
    return UserDb(
      map['username'] ?? '',
      map['firstname'] ?? '',
      map['lastname'] ?? '',
      map['role'] != null
          ? Role.values
              .firstWhere((role) => role.toString() == 'Role.${map['role']}')
          : Role.user,
      map['hotelId'] ?? '',
    );
  }
}
