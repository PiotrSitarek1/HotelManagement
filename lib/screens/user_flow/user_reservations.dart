import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/components/reservation_widget.dart';
// import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/screens/user_flow/reservation_placeholder.dart';

class UserReservationsView extends StatefulWidget {
  const UserReservationsView({super.key});

  @override
  State<StatefulWidget> createState() => _UserReservationsView();
}

class _UserReservationsView extends State<UserReservationsView> {
  final List<ReservationPlaceholder> _reservations = [
    ReservationPlaceholder(
        hotelname: 'Super Hotel', adress: 'Boat city 98-323'),
    ReservationPlaceholder(
        hotelname: 'Super Hotel2', adress: 'Boat city 98-323'),
    ReservationPlaceholder(
        hotelname: 'Super Hotel3', adress: 'Boat city 98-323')
  ];

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
                "Current Reservations",
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              height: hotelsHeight,
              child: ListView.builder(
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  return ReservationWidget(
                    reservation: _reservations[index],
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
