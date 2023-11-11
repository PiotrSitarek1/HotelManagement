import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/user_settings_screen.dart';
import 'package:hotel_manager/services/user_auth.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:hotel_manager/utils/Roles.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_manager/models/user_model.dart';

class RegisterVisitorView extends StatefulWidget {
  const RegisterVisitorView({Key? key});

  @override
  _RegisterVisitorViewState createState() => _RegisterVisitorViewState();
}

class _RegisterVisitorViewState extends State<RegisterVisitorView> {
  final UserAuth _userAuth = UserAuth();
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool acceptTerms = false;

  void _register() {
    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please accept the terms of use and privacy policy')),
      );
    } else {
      _registerIfPossible();
    }
  }

  void _navigateToUserSettings() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UserSettingsView(),
    ));
  }

  void _showSnackbar(BuildContext context, String username) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(username),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _registerIfPossible() async {
    UserCredential? userCredential = await _userAuth.signUp(
        emailController.text.trim(), passwordController.text.trim());
    if (userCredential != null) {
      UserDb user = UserDb(firstNameController.text, firstNameController.text,
          lastNameController.text, Role.user, "0");
      _userService.addUser(userCredential.user!.uid, user);
      _showSnackbar(context, "Registered");
      _navigateToUserSettings();
    } else {
      _showSnackbar(context, "Registration failed");
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginView(),
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
                        'Sign Up',
                        style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Last Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            acceptTerms = value!;
                          });
                        },
                      ),
                      const Flexible(
                        child: Text(
                          'I accept the terms of use and privacy policy',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && acceptTerms) {
                        _register();
                      } else if (!acceptTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please accept the terms of use and privacy policy')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please fill input or passwords do not match')),
                        );
                      }
                    },
                    child: Text('Sign Up',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: customBlueAccent,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: const Text(
                      'I already have an account',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
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
}
