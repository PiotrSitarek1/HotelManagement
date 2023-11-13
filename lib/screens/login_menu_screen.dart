import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/change_password_screen.dart';
import 'package:hotel_manager/screens/login_screen.dart';
import 'package:hotel_manager/screens/sign_up_choice_screen.dart';

class LoginMenuView extends StatefulWidget {
  const LoginMenuView({Key? key});

  @override
  _LoginMenuViewState createState() => _LoginMenuViewState();
}

class _LoginMenuViewState extends State<LoginMenuView> {
  void _navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginView(),
    ));
  }

  void _navigateToRegister() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ));
  }

  void _navigateToForgotPassword() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ChangePasswordView(),
    ));
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
                const SizedBox(height: 64),
                ElevatedButton(
                  onPressed: _navigateToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBluePrimary, // Background color
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),

                const SizedBox(height: 64),
                GestureDetector(
                  onTap: _navigateToForgotPassword,
                  child: Text("FORGOT PASSWORD",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w900,
                          color: customBlueAccent)),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an account yet?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: _navigateToRegister,
                    child: Text("Sign up",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: customBlueAccent)),
                  )
                ])
              ],
            ),
          ),
        ));
  }
}
