//todo it's gonna be throwen away after implementing backend
class ReservationPlaceholder {
  String date = '';
  String dateEnd = '';
  String imageUrl = '';
  String hotelname = '';
  String adress = '';
  String services = '';

  ReservationPlaceholder({required this.hotelname, required this.adress, required this.date, required this.dateEnd, required this.imageUrl});
}
//  Hotel({
  //   required this.name,
  //   required this.address,
  //   String? email,
  //   String? phoneNumber,
  //   String? imageUrl,
  //   String? supervisorId,
  //   this.services = const [],
  // })  : email = email ?? '',
  //       phoneNumber = phoneNumber ?? '',
  //       supervisorId = supervisorId ?? '',
  //       imageUrl = imageUrl ?? '';