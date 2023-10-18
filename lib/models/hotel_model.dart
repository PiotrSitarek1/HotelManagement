class Hotel {
  final String name;
  final String address;
  final String contact;
  final String imageUrl;
  final int supervisorId;
  final List<int> services;

  Hotel(this.name, this.address, this.contact, this.imageUrl, this.supervisorId,
      this.services);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'contact': contact,
      'imageUrl': imageUrl,
      'supervisorId': supervisorId,
      'services': services,
    };
  }

  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      map['name'],
      map['address'],
      map['contact'],
      map['imageUrl'],
      map['supervisorId'] as int,
      List<int>.from(map['services'] ?? []),
    );
  }
}
