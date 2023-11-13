import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/hotel_model.dart';

class HotelWidget extends StatelessWidget {
  final Hotel hotel;

  const HotelWidget({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                //todo protection from null or invalid URL adress
                image: NetworkImage(hotel.imageUrl),
                fit: BoxFit.cover),
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
                          image: NetworkImage(hotel.imageUrl),
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
                          Text(hotel.contact,
                              style: GoogleFonts.roboto(
                                  fontSize: 14, color: Colors.white)),
                          Container(
                            child: ElevatedButton(
                                onPressed: () {},
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
