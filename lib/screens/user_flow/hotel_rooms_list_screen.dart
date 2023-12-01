import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotel_manager/components/room_widget.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/screens/user_flow/user_booking_screen.dart';
import 'package:hotel_manager/services/room_service.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:hotel_manager/utils/Utils.dart';

import '../../models/hotel_model.dart';
import '../../models/user_model.dart';

class HotelRoomsListView extends StatefulWidget {
  final Hotel hotel;
  const HotelRoomsListView({Key? key, required this.hotel}) : super(key: key);

  @override
  _HotelRoomsListView createState() => _HotelRoomsListView(hotel);
}

class _HotelRoomsListView extends State<HotelRoomsListView> {
  final UserService _userService = UserService();
  final Hotel hotel;
  _HotelRoomsListView(this.hotel){
    setRooms();
  }

  final RoomService _roomService = RoomService();
  late List<Room> _rooms = [];
  List<Room> _rooms2 = [
    Room('hotel_1', 'Single', 100, 10, true),
    Room('hotel_1', 'Double', 150, 20, false),
    Room('hotel_1', 'Biggo', 250, 5, true),
  ];

  void setRooms() async {
    String? hotelId = await _userService.getHotelByUserUID(hotel.supervisorId);
    _rooms2 = (await _roomService.getRoomsByHotelId(hotelId!))!;
  }

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
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        return RoomWidget(
                          room: _rooms[index],
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
    String? hotelId = await _userService.getHotelByUserUID(hotel.supervisorId);
    final temp = await _roomService.getRoomsByHotelId(hotelId!);

    if (temp == null) return;
    setState(() {
      _rooms = temp;
    });
  }
}
