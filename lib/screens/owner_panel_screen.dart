// owner_panel_screen.dart
import 'dart:io' show File;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/room_list_screen.dart';
import 'package:hotel_manager/screens/service_list_screen.dart';
import 'package:hotel_manager/screens/user_settings_screen.dart';
import 'package:hotel_manager/services/hotel_service.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:hotel_manager/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';

import '../models/hotel_model.dart';

class OwnerPanelScreen extends StatefulWidget {
  const OwnerPanelScreen({Key? key}) : super(key: key);

  @override
  _OwnerPanelScreenState createState() => _OwnerPanelScreenState();
}

class _OwnerPanelScreenState extends State<OwnerPanelScreen> {
  TextEditingController hotelNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late String uID;
  late String hotelID;
  final HotelService _hotelService = HotelService();
  File ? _pickedImage;

  @override
  void initState(){
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    uID = user!.uid;
    _getHotelData();
  }

  void _getHotelData() async {
    String? hotelID = await UserService().getHotelByUserUID(uID);
    if (hotelID == null || hotelID == "0" || hotelID == "USER_NOT_FOUND") {
      showToast("Error occurred while reading hotel");
    } else {
      Hotel? hotel = await _hotelService.getHotelById(hotelID);
      if (hotel == null) {
        showToast("Error occurred while reading hotel");
      } else {
        this.hotelID = hotelID;
        hotelNameController.text = hotel.name;
        addressController.text = hotel.address;
        emailController.text = hotel.email;
        phoneNumberController.text = hotel.phoneNumber;

        String hotelImageUrl = hotel.imageUrl;
        if (hotelImageUrl != "") {
          File? downloadedImage =
              await downloadImageFile(hotelImageUrl);

          if (downloadedImage != null) {
            setState(() {
              _pickedImage = downloadedImage;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 5),
                  const Text(
                    'Hotel Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      _pickedImage != null
                          ? Image.file(
                              _pickedImage!,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.hotel,
                              size: 72,
                              color: Colors.white70,
                            ),
                      const SizedBox(width: 7),
                      TextButton(
                        onPressed: _changeHotelPicture,
                        child: Text(
                          'Change Hotel Picture',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: hotelNameController,
                    decoration: const InputDecoration(
                      labelText: 'Hotel Name',
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserSettingsView(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'User Settings',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoomListScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Edit hotel's rooms",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceListScreen(hotelID),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Edit hotel's services",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: 150,
                      child: Center(
                        child: Text(
                          'Save Changes',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: customBlueAccent,
                          ),
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changeHotelPicture() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      showToast("No image selected");
      return;
    }
    setState(() {
      _pickedImage = File(pickedFile.path);
    });
  }

  Future<void> _saveChanges() async {
    String imageUrl = "";
    if (_pickedImage != null) {
      imageUrl =
          await uploadImageToFirebaseStorage(_pickedImage!);
    }

    Hotel updatedHotel = Hotel(
        name: hotelNameController.text,
        address: addressController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        supervisorId: uID,
        imageUrl: imageUrl);

    String result = await _hotelService.updateHotel(hotelID, updatedHotel);
    if (result == "SUCCESS") {
      showToast("Hotel updated successfully");
      _getHotelData();
    } else {
      showToast("Unexpected error: $result");
    }
  }
}
