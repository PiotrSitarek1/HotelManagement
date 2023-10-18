import 'package:hotel_manager/utils/Roles.dart';

class User {
  final String username;
  final Role role;
  final int hotelId;

  User(this.username, this.role, this.hotelId);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role.toString().split('.').last,
      'hotelId': hotelId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['username'],
      Role.values
          .firstWhere((role) => role.toString() == 'Role.${map['role']}'),
      map['hotelId'] as int,
    );
  }
}
