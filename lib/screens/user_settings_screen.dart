import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/services/user_auth.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../utils/Utils.dart';
import 'authentication_flow/change_password_screen.dart';
import 'authentication_flow/login_menu_screen.dart';

class UserSettingsView extends StatefulWidget {
  const UserSettingsView({Key? key});

  @override
  _UserSettingsViewState createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final UserService _userService = UserService();
  final UserAuth _userAuth = UserAuth();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  late String uID;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    uID = user!.uid;
    _getPersonalData();
  }

  void _navigateToChangePassword() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ChangePasswordView(),
    ));
  }

  void _signOut(){
    _userAuth.signOut();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
      const LoginMenuView(),//todo: block coming back to this page
    ));
  }

  Future<void> _getPersonalData() async {
    UserDb? userDb = await _userService.getUserByUID(uID);
    if (userDb == null) {
      showToast("Error occurred while reading user");
    } else {
      firstNameController.text = userDb.firstname;
      lastNameController.text = userDb.lastname;
      userNameController.text = userDb.username;

      String userImageUrl = userDb.imageUrl;
      if (userImageUrl != "") {
        File? downloadedImage = await downloadImageFile(userImageUrl);
        if (downloadedImage != null) {
          if(mounted){
            setState(() {
              _pickedImage = downloadedImage;
            });
          }
        }
      }
    }
  }

  Future<void> _changePersonalData() async {
    String imageUrl = "";
    if (_pickedImage != null) {
      imageUrl = await uploadImageToFirebaseStorage(_pickedImage!);
    }
    String result = await _userService.updateUserFields(
        uID,
        firstNameController.text,
        lastNameController.text,
        userNameController.text,
        imageUrl);
    if (result == "SUCCESS") {
      showToast("User updated successfully");
      _getPersonalData();
    } else {
      showToast("Unexpected error: $result");
    }
  }

  Future<void> _changeProfilePicture() async {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'User Settings',
                        style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                              IconData(0xe043, fontFamily: 'MaterialIcons'),
                              size: 72,
                              color: Colors.white70,
                            ),
                      const SizedBox(width: 7),
                      TextButton(
                        onPressed: _changeProfilePicture,
                        child: Text(
                          'Change Profile Picture',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: customBlueAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _navigateToChangePassword,
                    child: Text('Change Password',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: customBlueAccent)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _signOut,
                    child: Text('Sign out',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: customBlueAccent)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _changePersonalData,
                    child: Text('Save Changes',
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: customBlueAccent)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
