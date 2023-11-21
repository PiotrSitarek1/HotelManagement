import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_manager/models/hotel_model.dart';
import 'package:hotel_manager/screens/owner_flow/owner_panel_screen.dart';
import 'package:hotel_manager/services/hotel_service.dart';
import 'package:hotel_manager/utils/Utils.dart';
import '/models/user_model.dart';
import '/services/user_auth.dart';
import '/services/user_service.dart';
import '/utils/Roles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class RegisterOwnerView extends StatefulWidget {
  const RegisterOwnerView({super.key});

  @override
  _RegisterOwnerViewState createState() => _RegisterOwnerViewState();
}

class _RegisterOwnerViewState extends State<RegisterOwnerView> {
  final UserAuth _userAuth = UserAuth();
  final UserService _userService = UserService();
  final HotelService _hotelService = HotelService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool acceptTerms = false;

  final TextEditingController hotelNameController = TextEditingController();
  final TextEditingController hotelAddressController = TextEditingController();

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

  void _navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginView(),
    ));
  }

  void _navigateToOwnerFlow() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const OwnerPanelScreen(),
    ));
  }

  void _registerIfPossible() async {
    UserCredential? userCredential = await _userAuth.signUp(
        emailController.text.trim(), passwordController.text.trim());
    if (userCredential != null) {
      Hotel newHotel = Hotel(
          name: hotelNameController.text, address: hotelAddressController.text);
      String? hotelKey = await _hotelService.addHotel(newHotel);
      if (hotelKey == null) {
        showToast("Hotel registration failed");
        return;
      }
      UserDb newUser = UserDb(
          username: firstNameController.text,
          firstname: firstNameController.text,
          lastname: lastNameController.text,
          role: Role.supervisor,
          hotelId: hotelKey,
          activated: false);
      _userService.addUser(userCredential.user!.uid, newUser);
      showToast("User and Hotel registered - Hotel needs to be configured");

      _navigateToOwnerFlow();
    } else {
      showToast("Registration failed");
    }
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
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Sign Up',
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
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: TextFormField(
                        controller: hotelNameController,
                        decoration: const InputDecoration(
                          labelText: 'Hotel Name',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 12.0),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Hotel Name';
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
                        controller: hotelAddressController,
                        decoration: const InputDecoration(
                          labelText: 'Hotel Address',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 12.0),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Hotel Address';
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
                                content:
                                    Text('Please fill in all required fields')),
                          );
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: customBlueAccent),
                      ),
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
      ),
    );
  }
}
