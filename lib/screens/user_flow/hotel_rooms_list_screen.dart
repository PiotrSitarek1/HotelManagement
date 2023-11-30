import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotel_manager/components/room_widget.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/screens/user_flow/user_booking_screen.dart';
import 'package:hotel_manager/services/room_service.dart';

class HotelRoomsListView extends StatefulWidget {
  const HotelRoomsListView({super.key});

  @override
  _HotelRoomsListView createState() => _HotelRoomsListView();
}

class _HotelRoomsListView extends State<HotelRoomsListView> {
  final RoomService _roomService = RoomService();
  late List<Room> _rooms = [];
  final List<Room> _rooms2 = [
    Room('hotel_1', 'Single', 100, 10, true),
    Room('hotel_1', 'Double', 150, 20, false),
    Room('hotel_1', 'Biggo', 250, 5, true),
  ];
  @override
  void initState() {
    super.initState();
    getRooms();
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "List of Rooms",
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                child: Container(
                  color: const Color.fromRGBO(16, 7, 51, 70),
                  height: hotelsHeight,
                  child: SizedBox(
                    height: hotelsHeight,
                    child: ListView.builder(
                      itemCount: _rooms2.length,
                      itemBuilder: (context, index) {
                        return RoomWidget(
                          room: _rooms2[index], //todo zamienic na rooms
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getRooms() async {
    final temp = await _roomService
        .getRoomsByHotelId('id'); //todo przekazać hotel do tego widoku
    if (temp == null) return;
    setState(() {
      _rooms = temp;
    });
  }
}
