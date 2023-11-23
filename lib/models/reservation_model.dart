class Reservation {
  String userId;
  String hotelId;
  int roomNumber;
  DateTime checkInDate;
  DateTime checkOutDate;
  String status;
  bool cancellationAllowed;
  List<int> services;

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
      map['userId'] ?? '',
      map['hotelId'] ?? '',
      map['roomNumber'] ?? 0,
      DateTime.parse(map['checkInDate']),
      DateTime.parse(map['checkOutDate']),
      map['status'] ?? '',
      map['cancellationAllowed'] ?? true,
      List<int>.from(map['services'] ?? []),
    );
  }
}
