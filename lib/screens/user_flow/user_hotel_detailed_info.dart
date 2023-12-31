import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/components/service_widget.dart';
import 'package:hotel_manager/models/hotel_model.dart';
import 'package:hotel_manager/models/service_model.dart';
import 'package:hotel_manager/screens/user_flow/hotel_rooms_list_screen.dart';
import 'package:hotel_manager/services/hotel_service.dart';
import 'package:hotel_manager/services/user_service.dart';

import '../../utils/Utils.dart';

class UserHotelDetailedInfoScreen extends StatefulWidget {
  final Hotel hotel;

  const UserHotelDetailedInfoScreen({Key? key, required this.hotel})
      : super(key: key);

  @override
  _UserHotelDetailedInfoScreen createState() =>
      _UserHotelDetailedInfoScreen(hotel);
}

class _UserHotelDetailedInfoScreen extends State<UserHotelDetailedInfoScreen> {
  String hotelName = "", adress = "", email = "", phoneNum = "", imageUrl = "";
  final Hotel hotel;
  _UserHotelDetailedInfoScreen(this.hotel);
  HotelService _hotelService = HotelService();
  File? _image;

  final List<Service> _services = [];

  setHotelData() async {
    UserService owner = UserService();
    String? hotelId = await owner.getHotelByUserUID(hotel.supervisorId);
    if (hotelId == null) return;

    final temp = await _hotelService.getServicesByHotelId(hotelId);
    if (temp == null) return;
    _services.clear();
    _services.addAll(temp);

    if(mounted){
      setState(() {
        hotelName = hotel.name;
        adress = hotel.address;
        email = hotel.email;
        phoneNum = hotel.phoneNumber;
        imageUrl = hotel.imageUrl;
        for(int i = 0; i < hotel.services.length; i++) {
          _services.add(Service(hotel.services[i].name, hotel.services[i].price));
        }
      });
      setImage();
    }
  }

  void _NavigateToRooms() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HotelRoomsListView(hotel: hotel),
        ));
  }

  Future<void> setImage() async {
    if (imageUrl != "") {
      File? downloadedImage = await downloadImageFile(imageUrl);
      if (downloadedImage != null) {
        if(mounted){
          setState(() {
            _image = downloadedImage;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setHotelData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Color customBlueAccent = Color.fromARGB(186, 5, 35, 75);
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
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Container(
                      width: (screenWidth - 20) / 2,
                      height: (screenHeight) / 3,
                      padding: const EdgeInsets.all(8),
                      child: _image != null
                          ? Image.file(
                              _image!,
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
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Container(
                      width: (screenWidth - 20) / 2,
                      height: (screenHeight) / 4,
                      color: customBlueAccent,
                      padding: const EdgeInsets.all(8),
                      child: Center(
                          child: Column(
                        children: [
                          Text(
                            hotelName,
                            style: GoogleFonts.roboto(
                                fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            adress,
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Contact:',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            phoneNum,
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Extra Services",
                style: GoogleFonts.roboto(
                    fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                child: Container(
                  width: (screenWidth - 40),
                  height: (screenHeight) / 2 - 20,
                  color: customBlueAccent,
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      return ServiceWidget('key', _services[index]);
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: _NavigateToRooms, child: const Text('Show Rooms'))
          ],
        ),
      ),
    );
  }
}
