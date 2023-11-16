class Service {
  late final String name;
  late final int price;

  Service(String? name, int? price)
      : name = name ?? 'Default',
        price = price ?? 0;

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price};
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      map['name'] ?? 'Default',
      map['price'] ?? 0,
    );
  }
}
