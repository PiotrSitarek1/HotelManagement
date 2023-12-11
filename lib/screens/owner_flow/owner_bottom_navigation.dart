import 'package:flutter/material.dart';
import 'package:hotel_manager/screens/owner_flow/pending_reservations_screen.dart';
import 'package:hotel_manager/screens/owner_flow/reservations_screen.dart';
import 'package:hotel_manager/screens/owner_flow/owner_panel_screen.dart';

class OwnerBottomNavigationView extends StatefulWidget {
  const OwnerBottomNavigationView({super.key});

  @override
  _OwnerBottomNavigationView createState() => _OwnerBottomNavigationView();
}

class _OwnerBottomNavigationView extends State<OwnerBottomNavigationView> {
  int _selectedIndex = 0;
  void _navigateBottomNavigationBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const PendingReservationsScreen(),
    const ReservationsScreen(),
    const OwnerPanelScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
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
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomNavigationBar,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions), label: 'Pending'),
            BottomNavigationBarItem(
                icon: Icon(Icons.event), label: 'Reservations'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Owner Panel'),
          ],
        ),
      ),
    );
  }
}
