import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';

import 'package:hotel_manager/components/service_widget_highlight.dart';
import 'package:hotel_manager/models/reservation_model.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/models/service_model.dart';
import 'package:hotel_manager/services/hotel_service.dart';
import 'package:hotel_manager/services/reservation_service.dart';

import '../../models/hotel_model.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../utils/Utils.dart';

class UserBookingView extends StatefulWidget {
  final Room room;
  const UserBookingView({Key? key, required this.room}) : super(key: key);

  @override
  _UserBookingView createState() => _UserBookingView(room);
}

class _UserBookingView extends State<UserBookingView> {
  DateTime? reservationDate = DateTime.now();
  DateTime? reservationEndDate = DateTime.now().add(const Duration(days: 1));
  final UserService _userService = UserService();
  final ReservationServices _reservationServices = ReservationServices();
  User? user = FirebaseAuth.instance.currentUser;
  final HotelService _hotelService = HotelService();
  int _totalPrice = 0;
  String hotelName = "",
      adress = "",
      contact = "",
      ownersName = "",
      ownersLastName = "";
  final List<Service> _services = [];
  final Room room;
  _UserBookingView(this.room);
  File? _hotelImage;
  File? _profileImage;

  Future<void> setData() async {
    Hotel? tempHotel = await _hotelService.getHotelById(room.hotelId);
    if (tempHotel == null) return;
    UserDb? owner = await _userService.getUserByUID(tempHotel.supervisorId);
    if (owner == null) return;
    final temp = await _hotelService.getServicesByHotelId(room.hotelId);
    if (mounted) {
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
        for (int i = 0; i < _services.length; i++) {
          _totalPrice += _services[i].price;
        }
      });
      setImage(owner.imageUrl, false);
      setImage(tempHotel.imageUrl, true);
    }
  }

  Future<void> setImage(String imageUrl, bool isHotelImage) async {
    if (imageUrl != "") {
      File? downloadedImage = await downloadImageFile(imageUrl);
      if (downloadedImage != null) {
        if (mounted) {
          setState(() {
            if (isHotelImage == true) {
              _hotelImage = downloadedImage;
            } else {
              _profileImage = downloadedImage;
            }
          });
        }
      }
    }
  }

  void reserveRoom() {
    _hotelService.getHotelById(room.hotelId);
    String uID = user!.uid;
    Reservation reservation = Reservation(uID, room.hotelId, room.number,
        reservationDate!, reservationEndDate!, "Pending", true, []);
    _reservationServices.addReservation(reservation);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  void _showDatePicker() {
    showDatePickerDialog(
      context: context,
      initialDate: DateTime.now(),
      minDate: DateTime(2021, 1, 1),
      maxDate: DateTime(2024, 12, 31),
    );
  }

  TappedChange tp = TappedChange();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                      child: _hotelImage != null
                          ? Image.file(
                              _hotelImage!,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              IconData(0xe043, fontFamily: 'MaterialIcons'),
                              size: 72,
                              color: Colors.white70,
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
                      child: _profileImage != null
                          ? Image.file(
                              _profileImage!,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              IconData(0xe043, fontFamily: 'MaterialIcons'),
                              size: 72,
                              color: Colors.white70,
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
                              Text(
                                  DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(reservationDate!),
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final date = await showDatePickerDialog(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    maxDate: DateTime.now()
                                        .add(const Duration(days: 365 * 3)),
                                    minDate: DateTime.now()
                                        .subtract(const Duration(days: 31)),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      if (date.compareTo(reservationEndDate!) <=
                                              0 &&
                                          date.compareTo(DateTime.now()) >= 0) {
                                        reservationDate = date;
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Invalid date");
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  "Edit",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple),
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Text(
                                  DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(reservationEndDate!),
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final date = await showDatePickerDialog(
                                    context: context,
                                    initialDate: DateTime.now()
                                        .add(const Duration(days: 1)),
                                    maxDate: DateTime.now()
                                        .add(const Duration(days: 365 * 3)),
                                    minDate: DateTime.now()
                                        .subtract(const Duration(days: 31)),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      if (date.compareTo(reservationDate!) >
                                          0) {
                                        reservationEndDate = date;
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Checkout date cannot be before checkin date");
                                      }
                                    });
                                  }
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
                                    tp: tp, service: _services[index]);
                              },
                            ),
                          ),
                          ListenableBuilder(
                            listenable: tp,
                            builder: (BuildContext context, Widget? child) {
                              _totalPrice += tp.price;
                              return Text(
                                'Total Price: ${_totalPrice}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: reserveRoom,
                  child: Text(
                    'Reserve',
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
