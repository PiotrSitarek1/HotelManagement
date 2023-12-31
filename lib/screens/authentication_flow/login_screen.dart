import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/owner_flow/owner_bottom_navigation.dart';
import 'package:hotel_manager/screens/authentication_flow/sign_up_choice_screen.dart';
import 'package:hotel_manager/screens/user_flow/user_bottom_navigation.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:hotel_manager/utils/Roles.dart';
import 'package:hotel_manager/utils/Utils.dart';
import '/models/user_model.dart';
import 'change_password_screen.dart';
import 'package:hotel_manager/services/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final UserAuth _userAuth = UserAuth();
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    _loginIfPossible();
  }

  Future<void> _loginIfPossible() async {
    UserCredential? userCredential = await _userAuth.signIn(
        emailController.text.trim(), passwordController.text.trim());
    if (userCredential != null) {
      UserDb? userDb =
          await _userService.getUserByUID(userCredential.user!.uid);

      if (userDb != null) {
        if (userDb.role == Role.supervisor) {
          if (!userDb.activated) {
            showToast("Account has not been activated yet");
            return;
          }
          _navigateToLoggedOwner();
        } else {
          _navigateToLoggedUser();
        }
      } else {
        showToast("User details not found");
      }
    }
  }

  void _closeKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _navigateToLoggedUser() {
    _closeKeyboard();
    emailController.text = "";
    passwordController.text = "";
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UserBottomNavigationView(),
    ));
  }

  void _navigateToLoggedOwner() {
    _closeKeyboard();
    emailController.text = "";
    passwordController.text = "";
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const OwnerBottomNavigationView(),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
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
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: Text('Login',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: customBlueAccent)),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _navigateToForgotPassword,
                      child: Text(
                        "FORGOT PASSWORD",
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "Don't have an account yet?",
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 14),
                      ),
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
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
