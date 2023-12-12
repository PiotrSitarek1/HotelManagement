import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/components/reservation_widget.dart';
import 'package:hotel_manager/screens/user_flow/reservation_placeholder.dart';
import 'package:hotel_manager/utils/Utils.dart';

import '../../services/reservation_service.dart';

class UserReservationsView extends StatefulWidget {
  const UserReservationsView({super.key});

  @override
  State<StatefulWidget> createState() => _UserReservationsView();
}

class _UserReservationsView extends State<UserReservationsView> {
  _UserReservationsView() {
    setReservations();
  }

  final List<ReservationPlaceholder> _reservations = [];

  final ReservationServices _reservationServices = ReservationServices();
  User? user = FirebaseAuth.instance.currentUser;
  late String uID;

  void setReservations() {
    addReservations();
  }

  void addReservations() async {
    uID = user!.uid;
    List<ReservationPlaceholder>? _newReservations =
        await _reservationServices.getBasicHotelInformationForUser(uID);
    if (_newReservations != null) {
      //showToast("Posiadasz ${_newReservations.length} rezerwcji");
      if(mounted){
        setState(() {
          _reservations.addAll(_newReservations);
        });
      }
    } else {
      showToast("Brak aktywnych rezerwacji");
    }
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
