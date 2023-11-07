import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_manager/services/hotel_service.dart';

import '../models/user_model.dart';
import '../services/user_auth.dart';
import '../services/user_service.dart';

class LoggedView extends StatefulWidget {
  const LoggedView({Key? key});

  @override
  _LoggedViewState createState() => _LoggedViewState();
}

class _LoggedViewState extends State<LoggedView> {
  final UserAuth _userAuth = UserAuth();
  final User? user = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
  final HotelService _hotelService = HotelService();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController roleTextController = TextEditingController();

  void _showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    UserDb? userDb = await _userService.getUserByUID(user!.uid);
    nameTextController.text = userDb!.firstname;
    roleTextController.text = userDb.role.name;
  }
  void editHotel() async {
    await _hotelService.updateHotelField('-NifTs-DUIPccoQxCC4g', 'name', 'Hotel B');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: nameTextController,
                decoration: InputDecoration(labelText: 'Text Field 1'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: roleTextController,
                decoration: InputDecoration(labelText: 'Text Field 2'),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _userAuth.signOut();
                    _showSnackbar(context, "Signed out");
                  },
                  child: Text('Sign out'),
                ),
                ElevatedButton(
                  onPressed: () {
                    editHotel();
                  },
                  child: Text('Edit hotel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
