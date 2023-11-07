class Hotel {
  final String name;
  final String address;
  final String contact;
  final String imageUrl;
  final String supervisorId;
  final List<int> services;

  Hotel({
    required this.name,
    required this.address,
    this.contact = '',
    this.imageUrl = '',
    this.supervisorId = '',
    this.services = const [],
  });

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
      name: map['name'],
      address: map['address'],
      contact: map['contact'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      supervisorId: map['supervisorId'] ?? '',
      services: List<int>.from(map['services'] ?? []),
    );
  }
}
