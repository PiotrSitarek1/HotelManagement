import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/login_menu_screen.dart';

class StartView extends StatefulWidget {
  const StartView({Key? key});

  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  void _navigateToLoginMenuScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginMenuView(),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        ));
  }
}
