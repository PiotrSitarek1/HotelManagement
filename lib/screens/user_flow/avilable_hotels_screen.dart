import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/components/hotel_widget.dart';
import 'package:hotel_manager/models/hotel_model.dart';

class AvilableHotelsView extends StatefulWidget {
  const AvilableHotelsView({super.key});

  @override
  _AvilableHotelsView createState() => _AvilableHotelsView();
}

class _AvilableHotelsView extends State<AvilableHotelsView> {
  final List<Hotel> _hotels = [
    Hotel(
        name: 'Hotel1',
        address: '123 Main Street',
        contact: '999-999-999',
        imageUrl:
            'https://pix8.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=1024x768',
        supervisorId: '1',
        services: [1, 2, 3]),
    Hotel(
        name: 'Hotel 2',
        address: 'Another Street 13',
        contact: '234-234-234',
        imageUrl:
            'https://pix8.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=1024x768',
        supervisorId: '1',
        services: [1, 2, 3]),
    Hotel(
        name: 'Hotel',
        address: 'HotelAdress',
        supervisorId: '1',
        services: [1, 2, 3]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blank_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "Available Hotels",
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              height: 520,
              child: ListView.builder(
                itemCount: _hotels.length,
                itemBuilder: (context, index) {
                  return HotelWidget(
                    hotel: _hotels[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
