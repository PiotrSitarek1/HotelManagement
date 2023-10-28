import 'package:flutter/material.dart';
import 'sign_up_visitor.dart';
import 'sign_up_hotel_owner_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color customPurpleColor = const Color(0xFF9E70FC);

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
            children: [
              const Text(
                'Wanna Sign up as?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterVisitorView(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customPurpleColor,
                ),
                child: const Text(
                  'VISITOR',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterOwnerView(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customPurpleColor,
                ),
                child: const Text(
                  'HOTEL OWNER',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
