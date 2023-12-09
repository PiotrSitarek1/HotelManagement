import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/reservation_model.dart';

import '../../models/room_model.dart';
import '../../models/user_model.dart';
import '../../services/reservation_service.dart';
import '../../services/room_service.dart';
import '../../services/user_service.dart';
import 'owner_botton_navigation.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final ReservationServices _reservationServices = ReservationServices();
  final Reservation reservation;
  final RoomService roomService = RoomService();
  final UserService userService = UserService();
  final String reservationId;

  ReservationDetailsScreen(
      {required this.reservation, required this.reservationId});

  @override
  Widget build(BuildContext context) {
    Color customBluePrimary = Colors.blueGrey;

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blank_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: customBluePrimary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 4),
                  blurRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reservation details',
                    style: GoogleFonts.roboto(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Room Number: ${reservation.roomNumber}',
                    style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Check-in Date: ${_formatDate(reservation.checkInDate)}',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Check-out Date: ${_formatDate(reservation.checkOutDate)}',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Status: ${reservation.status}',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Cancellation Allowed: ${reservation.cancellationAllowed}',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<UserDb?>(
                    future: userService.getUserByUID(reservation.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('User data not found.');
                      } else {
                        UserDb user = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              'User Information',
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Username: ${user.username}',
                              style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Name: ${user.firstname} ${user.lastname}',
                              style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            // Add more user information as needed
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _acceptReservation(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OwnerBottomNavigationView(),
                            ),
                          );
                        },
                        child: const Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _declineReservation(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OwnerBottomNavigationView(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                        ),
                        child: const Text('Decline'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _acceptReservation(context) async {
    try {
      reservation.status = 'Active';
      await _reservationServices.updateReservationStatus(
          reservationId, 'Active');
      setRoom(reservation, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation accepted successfully.'),
          backgroundColor: Colors.grey,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting reservation: $error'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  Future<void> _declineReservation(context) async {
    try {
      reservation.status = 'Declined';
      await _reservationServices.updateReservationStatus(
          reservationId, 'Declined');
      setRoom(reservation, false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation declined.'),
          backgroundColor: Colors.grey,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error declining reservation: $error'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  void setRoom(Reservation reservation, bool isActive) async {
    Room? room = await roomService.getRoomByNumber(reservation.roomNumber);
    String? roomId =
        await roomService.getRoomKeyByNumber(reservation.roomNumber);
    if (room == null) return;
    room.availability = !isActive;
    roomService.updateRoom(roomId!, room);
    return;
  }
}
