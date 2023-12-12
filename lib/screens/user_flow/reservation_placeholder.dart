class ReservationPlaceholder {
  String date = '';
  String dateEnd = '';
  String imageUrl = '';
  String hotelname = '';
  String adress = '';
  String services = '';

  //Todo
  String status = '';
  String contact = '';
  int roomNumber = 1;

  ReservationPlaceholder({
    required this.hotelname,
    required this.adress,
    required this.date,
    required this.dateEnd,
    required this.imageUrl,
    required this.roomNumber,
    required this.status,
  });
}
