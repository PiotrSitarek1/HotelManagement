// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotel_manager/components/service_widget_highlight.dart';
import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/models/service_model.dart';
import 'package:hotel_manager/services/hotel_service.dart';
import 'package:hotel_manager/services/reservation_service.dart';
import 'package:hotel_manager/services/user_auth.dart';

import '../../models/hotel_model.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class UserBookingView extends StatefulWidget {
  final Room room;
  const UserBookingView({Key? key, required this.room}) : super(key: key);

  @override
  _UserBookingView createState() => _UserBookingView(room);
}

class _UserBookingView extends State<UserBookingView> {
  final UserService _userService = UserService();
  final UserAuth _userAuth = UserAuth();
  final ReservationServices _reservationServices = ReservationServices();
  User? user = FirebaseAuth.instance.currentUser;
  final HotelService _hotelService = HotelService();
  int _totalPrice = 0;
  String hotelName = "", adress = "", contact = "", ownersName = "", ownersLastName = "";
  final List<Service> _services = [];
  final Room room;
  _UserBookingView(this.room);

  Future<void> setData() async{
    Hotel? tempHotel = await _hotelService.getHotelById(room.hotelId);
    if(tempHotel == null) return;
    UserDb? owner = await _userService.getUserByUID(tempHotel.supervisorId);
    if(owner == null) return;
    final temp = await _hotelService.getServicesByHotelId(room.hotelId);
    setState(() {
      hotelName = tempHotel.name;
      adress = tempHotel.address;
      contact = tempHotel.email;
      ownersName = owner.firstname;
      ownersLastName = owner.lastname;

      if (temp == null) return;
      _services.clear();
      _services.addAll(temp);

      _totalPrice = room.price;
      for(int i = 0; i < _services.length; i++){
         _totalPrice += _services[i].price;
       }
    });

  }

  void ReserveRoom(){
    _hotelService.getHotelById(room.hotelId);
    String uID = user!.uid;
    Reservation reservation = Reservation(uID, room.hotelId, room.number, DateTime.now(), DateTime.now(), "Pending", true, []);
    _reservationServices.addReservation(reservation);
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  // void _showDatePicker() {
  //   showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2022, 12, 12),
  //       lastDate: DateTime(2100, 12, 12));
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const imageUrl =
        "https://pix8.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=1024x768";
    const profileImageUrl =
        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";

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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 2),
                child: Text(
                  "Your Reservation",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        width: ((screenWidth) / 3) * 2,
                        height: (screenHeight) / 8,
                        color: Colors.white.withOpacity(0.5),
                        child: Column(children: [
                          Text(
                            hotelName,
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            adress,
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            contact,
                            style: GoogleFonts.roboto(fontSize: 18),
                          )
                        ]),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      width: (screenWidth - 100) / 3,
                      height: (screenHeight) / 8,
                      child: const Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Container(
                      width: (screenWidth - 100) / 3,
                      height: (screenHeight) / 8,
                      child: const Image(
                        image: NetworkImage(profileImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      child: Container(
                        width: ((screenWidth) / 3) * 2,
                        height: (screenHeight) / 8,
                        color: Colors.white.withOpacity(0.5),
                        child: Column(children: [
                          Text(
                            'Hotel Owner',
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ownersName,
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            ownersLastName,
                            style: GoogleFonts.roboto(fontSize: 18),
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Date and Services Summary',
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w900),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    height: screenHeight / 2 - 40,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 32,
                              ),
                              Text('Date: 03.12.2023',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //_showDatePicker;
                                },
                                child: Text(
                                  "Edit",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight / 2 - 100,
                            child: ListView.builder(
                              itemCount: _services.length,
                              itemBuilder: (context, index) {
                                return ServiceWidgetHighlight(
                                    service: _services[index]);
                              },
                            ),
                          ),
                          Text(
                            'Total Price : ${_totalPrice}', //Todo count the total price, room + services
                            textAlign: TextAlign.right,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: ReserveRoom,
                  child: Text(
                    'Reserve',
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
