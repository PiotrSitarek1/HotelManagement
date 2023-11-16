import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/sign_up_choice_screen.dart';
import 'package:hotel_manager/screens/user_flow/user_bottom_navigation.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:hotel_manager/utils/Roles.dart';
import 'package:hotel_manager/utils/toast.dart';
import '../models/reservation_model.dart';
import '../models/user_model.dart';
import 'change_password_screen.dart';
import 'package:hotel_manager/services/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_manager/services/reservation_service.dart';

class ReservationView extends StatefulWidget {
  const ReservationView({super.key});

  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  final UserAuth _userAuth = UserAuth();
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ReservationServices _reservationServices = ReservationServices();
  User? user = FirebaseAuth.instance.currentUser;
  late String uID;



  void _addReservation() async{
  //Ta funkcja tylko dodaje, nie sprawdza nic
    uID = user!.uid;
    UserDb? userDb = await _userService.getUserByUID(uID);

    if(userDb?.role == Role.user){
      Reservation reservation = Reservation(uID, "nie_dziala_id_usun", 401, DateTime(2023,11,19), DateTime(2023,11,23), "Active", true, []);
      _reservationServices.addReservation(reservation);
    }
    else{
      if(userDb != null) {
        _showReservations(userDb);
      }
    }
  }
  void _showReservations(UserDb userDb) async {
    Map<String,
        dynamic>? getReservationFromSingleHotel = await _reservationServices
        .getReservationFromSingleHotel(userDb.hotelId);
    if (getReservationFromSingleHotel != null) {
      int abc = getReservationFromSingleHotel.length;
      showToast(abc.toString());
    }
    else{
      showToast(0 as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 10.0;
    Color customBluePrimary = Colors.blueGrey;
    Color customBlueAccent = const Color.fromARGB(255, 5, 35, 75);

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
              color: customBluePrimary,
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addReservation();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: Text('Login',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: customBlueAccent)),
                    ),
                ]),
              ),
            ),
          ),
        ),
      )
    );
  }
}
