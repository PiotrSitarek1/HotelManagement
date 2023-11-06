import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginMenuView extends StatefulWidget {
  const LoginMenuView({Key? key});

  @override
  _LoginMenuViewState createState() => _LoginMenuViewState();
}

class _LoginMenuViewState extends State<LoginMenuView> {
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
                Text("Let's get on board",
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
                const SizedBox(height: 96),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Background color
                  ),
                  child: Text(
                    'Login as Visitor',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                //const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Background color
                  ),
                  child: Text(
                    'Login as Manager',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {},
                  child: Text("FORGOT PASSWORD",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(255, 8, 48, 117))),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Not a member?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text("Sign up",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 8, 48, 117))),
                  )
                ])
              ],
            ),
          ),
        ));
  }
}
