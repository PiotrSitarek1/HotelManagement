class Service {
  String name;
  int price;

  Service(this.name,this.price);

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price};
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      map['name'] ?? '',
      map['price'] ?? 0,
    );
  }
}
