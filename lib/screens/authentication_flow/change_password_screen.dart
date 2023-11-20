import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/services/user_auth.dart';
import '/utils/Utils.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key});

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final UserAuth _userAuth = UserAuth();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  void _changePassword() async {
    AuthStatus status =
        await _userAuth.resetPassword(emailController.text.trim());
    if (status == AuthStatus.successful) {
      showToast("Email sended");
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
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Change Password',
                          style: GoogleFonts.roboto(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
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
                        obscureText: false,
                        decoration: const InputDecoration(
                          labelText: 'email',
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
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _changePassword();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please fill input or passwords do not match')),
                          );
                        }
                      },
                      child: Text('Change Password',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: customBlueAccent,
                              fontWeight: FontWeight.bold)),
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
