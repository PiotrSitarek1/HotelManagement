
class Room {
  final int hotelId;
  final String type;
  final double price;
  final int number;
  final bool availability;

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
      map['hotelId'] as int,
      map['type'] as String,
      (map['price'] as num).toDouble(),
      map['number'] as int,
      map['availability'] as bool,
    );
  }
}
