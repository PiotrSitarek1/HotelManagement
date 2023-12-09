import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/screens/owner_flow/reservation_details_screen.dart';
import 'package:hotel_manager/services/reservation_service.dart';
import 'package:hotel_manager/services/room_service.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PendingReservationsScreen extends StatefulWidget {
  const PendingReservationsScreen({Key? key}) : super(key: key);

  @override
  _PendingReservationsScreenState createState() =>
      _PendingReservationsScreenState();
}

class _PendingReservationsScreenState extends State<PendingReservationsScreen> {
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
                  future: _reservationServices
                      .getSpecificReservationsFromSingleHotel(
                          hotelID, 'Pending'),
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
                                  'Pending Reservations',
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
    return InkWell(
      onTap: () {
        // Navigate to reservation details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationDetailsScreen(
                reservation: reservation, reservationId: key),
          ),
        );
      },
      child: Container(
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
                const SizedBox(width: 15),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Room ${reservation.roomNumber}',
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Check-In:\n${_formatDate(reservation.checkInDate)}',
                    style: GoogleFonts.roboto(fontSize: 13.0),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Check-Out:\n${_formatDate(reservation.checkOutDate)}',
                    style: GoogleFonts.roboto(fontSize: 13.0),
                  ),
                ),
              ],
            ),
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
