//todo it's gonna be throwen away after implementing backend
class ReservationPlaceholder {
  String date = '';
  String dateEnd = '';
  String imageUrl = '';
  String hotelname = '';
  String adress = '';
  String services = '';
  String status = '';

  int roomNumber;

  ReservationPlaceholder({
    required this.hotelname,
    required this.adress,
    required this.date,
    required this.dateEnd,
    required this.imageUrl,
    required this.roomNumber,
  });
}
