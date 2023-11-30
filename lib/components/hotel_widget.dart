import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/user_flow/user_hotel_detailed_info.dart';

import '../models/hotel_model.dart';

class HotelWidget extends StatelessWidget {
  final Hotel hotel;

  const HotelWidget({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    void _NavigateToHotelDetails() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserHotelDetailedInfoScreen(),
          ));
    }

    String imageUrl = hotel.imageUrl;

    if (Uri.tryParse(imageUrl)?.isAbsolute == false) {
      imageUrl =
          'https://img.freepik.com/darmowe-wektory/plaskie-tlo-fasady-hotelu_23-2148157379.jpg?size=338&ext=jpg&ga=GA1.1.1826414947.1699747200&semt=sph';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl), fit: BoxFit.cover),
          ),
          height: 400,
          child: Center(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 350,
              width: 350,
              color: const Color.fromRGBO(16, 7, 51, 70),
              child: Center(
                child: Container(
                  height: 300,
                  width: 300,
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        height: 300,
                        width: 150,
                        child: Image(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              hotel.name,
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(hotel.address,
                              style: GoogleFonts.roboto(
                                  fontSize: 14, color: Colors.white)),
                          Text(hotel.email,
                              style: GoogleFonts.roboto(
                                  fontSize: 14, color: Colors.white)),
                          Container(
                            child: ElevatedButton(
                                onPressed: _NavigateToHotelDetails,
                                child: Text(
                                  "More Information",
                                  style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
