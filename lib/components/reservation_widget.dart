import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/user_flow/reservation_placeholder.dart';

class ReservationWidget extends StatelessWidget {
  final ReservationPlaceholder reservation;

  const ReservationWidget({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    String imageUrl = reservation.imageUrl;

    if (imageUrl == '' || Uri.tryParse(imageUrl)?.isAbsolute == false) {
      imageUrl =
          'https://img.freepik.com/darmowe-wektory/plaskie-tlo-fasady-hotelu_23-2148157379.jpg?size=338&ext=jpg&ga=GA1.1.1826414947.1699747200&semt=sph';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
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
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            reservation.hotelname,
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            reservation.adress,
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Details'),
                            )),
                      ],
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
    );
  }
}
