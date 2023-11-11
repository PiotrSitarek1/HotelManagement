import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/services/user_service.dart';
import '../models/user_model.dart';
import 'change_password_screen.dart';

class UserSettingsView extends StatefulWidget {
  const UserSettingsView({Key? key});

  @override
  _UserSettingsViewState createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final UserService _userService = UserService();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  late String uID;

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

  Future<void> _getPersonalData() async {
    // TODO: Read more fields
    UserDb? userDb = await _userService.getUserByUID(uID);
    firstNameController.text = userDb!.firstname;
    lastNameController.text = userDb.lastname;
  }

  void _changePersonalData() {
    // TODO: Add logic to change personal data
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
  }

  void _changeProfilePicture() {
    // TODO: Add logic to change the profile picture
    // Implement image picker and update the user's profile picture.
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
                      const Icon(
                        IconData(0xe043, fontFamily: 'MaterialIcons'),
                        color: CupertinoColors.lightBackgroundGray,
                        size: 72,
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
