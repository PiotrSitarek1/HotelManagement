import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/screens/user_flow/user_booking_screen.dart';

class RoomWidget extends StatelessWidget {
  final Room room;

  const RoomWidget({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    void _navigateToBooking() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserBookingView(),
          ));
    }

    final bool enable = room.availability;

    final ElevatedButton buttonActive = ElevatedButton(
      onPressed: _navigateToBooking,
      child: Text(
        'Book',
        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );

    final ElevatedButton buttonDisabled = ElevatedButton(
      onPressed: null,
      child: Text(
        'Taken',
        style: GoogleFonts.roboto(
            fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: enable
            ? Colors.white.withOpacity(0.9)
            : Colors.grey.withOpacity(0.9),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Room number: ${room.number} ',
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' Price: ${room.price}',
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Room Type: ${room.type} ',
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  height: 35, child: enable ? buttonActive : buttonDisabled)
            ],
          ),
        ),
      ),
    );
  }
}
