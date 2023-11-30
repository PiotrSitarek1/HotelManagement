// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotel_manager/components/room_widget.dart';
import 'package:hotel_manager/components/service_widget_highlight.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/models/service_model.dart';
import 'package:hotel_manager/services/room_service.dart';

class UserBookingView extends StatefulWidget {
  const UserBookingView({super.key});

  @override
  _UserBookingView createState() => _UserBookingView();
}

class _UserBookingView extends State<UserBookingView> {
  final int _totalPrice = 999;
  final List<Service> _services = [
    Service('Spa', 50),
    Service('Gym', 75),
    Service('Billard', 100),
    Service('Restaurant', 50),
  ];

  @override
  void initState() {
    super.initState();
  }

  // void _showDatePicker() {
  //   showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2022, 12, 12),
  //       lastDate: DateTime(2100, 12, 12));
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const imageUrl =
        "https://pix8.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=1024x768";
    const profileImageUrl =
        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blank_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 2),
                child: Text(
                  "Your Reservation",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        width: ((screenWidth) / 3) * 2,
                        height: (screenHeight) / 8,
                        color: Colors.white.withOpacity(0.5),
                        child: Column(children: [
                          Text(
                            'Hotel Name',
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Adress',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            'Contact',
                            style: GoogleFonts.roboto(fontSize: 18),
                          )
                        ]),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      width: (screenWidth - 100) / 3,
                      height: (screenHeight) / 8,
                      child: const Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Container(
                      width: (screenWidth - 100) / 3,
                      height: (screenHeight) / 8,
                      child: const Image(
                        image: NetworkImage(profileImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      child: Container(
                        width: ((screenWidth) / 3) * 2,
                        height: (screenHeight) / 8,
                        color: Colors.white.withOpacity(0.5),
                        child: Column(children: [
                          Text(
                            'Hotel Owner',
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Lorem',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            'Ipsum',
                            style: GoogleFonts.roboto(fontSize: 18),
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Date and Services Summary',
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w900),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    height: screenHeight / 2 - 40,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 32,
                              ),
                              Text('Date: 03.12.2023',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //_showDatePicker;
                                },
                                child: Text(
                                  "Edit",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight / 2 - 100,
                            child: ListView.builder(
                              itemCount: _services.length,
                              itemBuilder: (context, index) {
                                return ServiceWidgetHighlight(
                                    service: _services[index]);
                              },
                            ),
                          ),
                          Text(
                            'Total Price : ${_totalPrice}', //Todo count the total price, room + services
                            textAlign: TextAlign.right,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Reserve',
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
