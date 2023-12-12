import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/user_flow/reservation_placeholder.dart';
import 'package:intl/intl.dart';

class ReservationWidget extends StatefulWidget {
  final ReservationPlaceholder reservation;

  ReservationWidget({required this.reservation, Key? key}) : super(key: key);

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.reservation.imageUrl;

    if (imageUrl == '' || Uri.tryParse(imageUrl)?.isAbsolute == false) {
      imageUrl =
          'https://img.freepik.com/darmowe-wektory/plaskie-tlo-fasady-hotelu_23-2148157379.jpg?size=338&ext=jpg&ga=GA1.1.1826414947.1699747200&semt=sph';
    }
    DateTime checkInDate = DateTime.parse(widget.reservation.date);
    DateTime checkOutDate = DateTime.parse(widget.reservation.dateEnd);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ColorFiltered(
          colorFilter: widget.reservation.status ==
                  'old' //Changes the color if status == old
              ? ColorFilter.mode(
                  Colors.grey,
                  BlendMode.color,
                )
              : ColorFilter.mode(Colors.transparent, BlendMode.saturation),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 250,
                  width: 350,
                  color: const Color.fromRGBO(16, 7, 51, 70),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 220,
                  width: 320,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                widget.reservation.hotelname,
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                widget.reservation.adress,
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Text(
                              'Contact: ${widget.reservation.services}',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Reservation Time:',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${DateFormat('yyyy-MM-dd hh:mm').format(checkInDate)}',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${DateFormat('yyyy-MM-dd hh:mm').format(checkOutDate)}',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                'Room Number : ${widget.reservation.roomNumber}',
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Status : ${widget.reservation.status}',
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          height: 200,
                          width: 150,
                          child: Image(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
