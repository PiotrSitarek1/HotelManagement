import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/components/hotel_widget.dart';
import 'package:hotel_manager/models/hotel_model.dart';

import '../../services/hotel_service.dart';

class AvailableHotelsView extends StatefulWidget {
  const AvailableHotelsView({super.key});

  @override
  _AvailableHotelsView createState() => _AvailableHotelsView();
}

class _AvailableHotelsView extends State<AvailableHotelsView> {
  final HotelService _hotelService = HotelService();
  late List<Hotel> _hotels = [];

  @override
  void initState(){
    super.initState();
    getHotels();
  }

  @override
  Widget build(BuildContext context) {
    final currHeight = MediaQuery.of(context).size.height;
    final hotelsHeight = currHeight -
        kToolbarHeight -
        20 -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top;

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
            SizedBox(
              height: hotelsHeight,
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

  Future<void> getHotels() async{
    final temp = await _hotelService.getAllHotels();
    if(temp == null) return;
    setState(() {
      _hotels = temp;
    });
  }
}
