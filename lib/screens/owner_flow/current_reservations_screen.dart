import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/services/reservation_service.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentReservationsScreen extends StatefulWidget {
  const CurrentReservationsScreen({Key? key}) : super(key: key);

  @override
  _CurrentReservationsScreenState createState() =>
      _CurrentReservationsScreenState();
}

class _CurrentReservationsScreenState extends State<CurrentReservationsScreen> {
  final ReservationServices _reservationServices = ReservationServices();
  late String hotelID;
  late String uID;
  late List<Reservation> reservations;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    uID = user!.uid;
    reservations = [];
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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No current reservations.'));
                    } else {
                      final reservationsMap = snapshot.data!;
                      reservations.clear();

                      reservationsMap.forEach((key, value) {
                        Reservation reservation = Reservation.fromMap({
                          'userId': value['userId'],
                          'hotelId': value['hotelId'],
                          'roomNumber': value['roomNumber'],
                          'checkInDate': DateTime.parse(value['checkInDate']),
                          'checkOutDate': DateTime.parse(value['checkOutDate']),
                          'status': value['status'],
                          'cancellationAllowed': value['cancellationAllowed'],
                          'services': List<int>.from(value['services'] ?? []),
                        });

                        reservations.add(reservation);
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Reservations',
                            style: GoogleFonts.roboto(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: reservations.length,
                              itemBuilder: (context, index) {
                                final reservation = reservations[index];
                                return buildReservationTile(reservation);
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

  Widget buildReservationTile(Reservation reservation) {
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
              SizedBox(
                width: 90,
                child: Text(
                  'Room ${reservation.roomNumber ?? 'N/A'}',
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 60,
                child: Text(
                  'Status: ${reservation.status ?? 'N/A'}',
                  style: GoogleFonts.roboto(fontSize: 14.0),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 90,
                child: Text(
                  'Check-In:\n${_formatDate(reservation.checkInDate)}\n'
                  'Check-Out:\n${_formatDate(reservation.checkOutDate)}',
                  style: GoogleFonts.roboto(fontSize: 10.0),
                ),
              ),
              SizedBox(
                width: 40,
                child: Checkbox(
                  value: reservation.status == 'Active',
                  onChanged: (value) async {
                    await _acceptReservation(reservation, value ?? false);
                  },
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

  Future<void> _acceptReservation(
      Reservation reservation, bool newValue) async {
    try {
      reservation.status = newValue ? 'Active' : 'Pending';
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Reservation accepted successfully.'),
            backgroundColor: Colors.grey),
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
}
