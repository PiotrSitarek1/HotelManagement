import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/services/reservation_service.dart';
import 'package:hotel_manager/services/room_service.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/room_model.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  _ReservationsScreenState createState() =>
      _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final ReservationServices _reservationServices = ReservationServices();
  final RoomService roomService = RoomService();
  late String hotelID;
  late String uID;
  late List<Reservation> reservations;
  late List<String> reservationsKeys;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    uID = user!.uid;
    reservations = [];
    reservationsKeys = [];
  }

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            future: _getHotelId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return FutureBuilder<Map<String, dynamic>?>(
                  future: _reservationServices.getReservationFromSingleHotel(
                    hotelID,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Stack(
                        children: [
                          Image.asset(
                            "assets/images/blank_background.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No current reservations.'));
                    } else {
                      final reservationsMap = snapshot.data!;
                      reservations.clear();
                      reservationsKeys.clear();

                      reservationsMap.forEach((key, value) {
                        reservations.add(value);
                        reservationsKeys.add(key);
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'Reservations',
                                  style: GoogleFonts.roboto(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: reservations.length,
                              itemBuilder: (context, index) {
                                final reservation = reservations[index];
                                final reservationKey = reservationsKeys[index];
                                return buildReservationTile(
                                    reservationKey, reservation);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildReservationTile(String key, Reservation reservation) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white.withOpacity(0.9),
        child: ListTile(
          title: Row(
            children: [
              const SizedBox(width: 5),
              SizedBox(
                width: 90,
                child: Text(
                  'Room ${reservation.roomNumber}',
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 80,
                child: Text(
                  'Status: ${reservation.status}',
                  style: GoogleFonts.roboto(fontSize: 14.0),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 100,
                child: Text(
                  'Check-In:\n${_formatDate(reservation.checkInDate)}\n'
                  'Check-Out:\n${_formatDate(reservation.checkOutDate)}',
                  style: GoogleFonts.roboto(fontSize: 10.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<String> _getHotelId() async {
    hotelID = (await UserService().getHotelByUserUID(uID))!;
    return hotelID;
  }
}
