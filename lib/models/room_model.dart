
class Room {
  String hotelId;
  String type;
  int price;
  int number;
  bool availability;

  Room(this.hotelId, this.type, this.price, this.number, this.availability);

  Map<String, dynamic> toMap() {
    return {
      'hotelId': hotelId,
      'type': type,
      'price': price,
      'number': number,
      'availability': availability,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      map['hotelId'] ?? '',
      map['type'] ?? '',
      map['price'] ?? 0,
      map['number'] ?? 0,
      map['availability'] ?? true,
    );
  }
}
