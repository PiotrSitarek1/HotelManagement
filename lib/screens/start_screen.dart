import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/authentication_flow/login_menu_screen.dart';
import 'package:hotel_manager/screens/user_flow/user_bottom_navigation.dart';

import '/services/user_auth.dart';
import 'owner_flow/owner_bottom_navigation.dart';

import 'package:flutter/services.dart';


class StartView extends StatefulWidget {
  const StartView({Key? key});

  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  final UserAuth _userAuth = UserAuth();

  void _navigateToLoginMenuScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginMenuView(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
      child: Scaffold(
        appBar: null,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/blank_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Hotel Manager App",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                //TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                const SizedBox(height: 16),
                const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 16),
                Text(
                  "Our hospitality at your service",
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 128),
                ElevatedButton(
                  onPressed: _navigateToLoginMenuScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Background color
                  ),
                  child: Text(
                    'GET STARTED',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 48), // Adjusted spacing
                ElevatedButton(
                  onPressed: _navigateToUserLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  child: Text(
                    'FAST USER LOGIN',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Adjusted spacing
                ElevatedButton(
                  onPressed: _navigateToOwnerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  child: Text(
                    'FAST OWNER LOGIN',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  // TODO: temp methods for faster login process, delete later ---- change UserSettingsView
  Future<void> _navigateToUserLogin() async {
    await _userAuth.signIn("user@gmail.com", "user123");
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UserBottomNavigationView(),
    ));
  }

  Future<void> _navigateToOwnerLogin() async {
    await _userAuth.signIn("owner@gmail.com", "owner123");
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const OwnerBottomNavigationView(),
    ));
  }
}
