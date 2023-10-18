class Reservation {
  final int userId;
  final int hotelId;
  final int roomNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status;
  final bool cancellationAllowed;
  final List<int> services;

  Reservation(this.userId, this.hotelId, this.roomNumber, this.checkInDate,
      this.checkOutDate, this.status, this.cancellationAllowed, this.services);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'hotelId': hotelId,
      'roomNumber': roomNumber,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'status': status,
      'cancellationAllowed': cancellationAllowed,
      'services': services,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      map['userId'] as int,
      map['hotelId'] as int,
      map['roomNumber'] as int,
      DateTime.parse(map['checkInDate']),
      DateTime.parse(map['checkOutDate']),
      map['status'] as String,
      map['cancellationAllowed'] as bool,
      List<int>.from(map['services'] ?? []),
    );
  }
}
