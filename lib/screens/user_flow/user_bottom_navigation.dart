import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/screens/user_flow/avilable_hotels_screen.dart';
import 'package:hotel_manager/screens/user_settings_screen.dart';

class UserBottomNavigationView extends StatefulWidget {
  const UserBottomNavigationView({super.key});

  @override
  _UserBottomNavigationView createState() => _UserBottomNavigationView();
}

class _UserBottomNavigationView extends State<UserBottomNavigationView> {
  int _selectedIndex = 0;

  void _navigateBottomNavigationBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const AvilableHotelsView(),
    Center(
      child: Text(
        'Reservations\n Page',
        style: GoogleFonts.roboto(fontSize: 24),
      ),
    ),
    const UserSettingsView()
  ];

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
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomNavigationBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.hotel), label: 'Reservations'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
