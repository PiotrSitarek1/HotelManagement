import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/components/service_widget.dart';
import 'package:hotel_manager/models/service_model.dart';
import 'package:hotel_manager/screens/user_flow/user_bottom_navigation.dart';

class UserHotelDetailedInfoScreen extends StatefulWidget {
  const UserHotelDetailedInfoScreen({Key? key}) : super(key: key);

  @override
  _UserHotelDetailedInfoScreen createState() => _UserHotelDetailedInfoScreen();
}

class _UserHotelDetailedInfoScreen extends State<UserHotelDetailedInfoScreen> {
  final List<Service> _services = [
    Service('Spa', 50),
    Service('Gym', 75),
    Service('Billard', 100),
    Service('Restaurant', 50),
  ];

  void _navigateToHotelsList() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UserBottomNavigationView(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const imageUrl =
        "https://pix8.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=1024x768";
    Color customBlueAccent = Color.fromARGB(186, 5, 35, 75);
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blank_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Container(
                      width: (screenWidth - 20) / 2,
                      height: (screenHeight) / 3,
                      padding: const EdgeInsets.all(8),
                      child: const Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Container(
                      width: (screenWidth - 20) / 2,
                      height: (screenHeight) / 4,
                      color: customBlueAccent,
                      padding: const EdgeInsets.all(8),
                      child: Center(
                          child: Column(
                        children: [
                          Text(
                            'Hotel Name',
                            style: GoogleFonts.roboto(
                                fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'Adress',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Contact:',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Email@email.com',
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            ' 425 425 425',
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Extra Services",
                style: GoogleFonts.roboto(
                    fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                child: Container(
                  width: (screenWidth - 40),
                  height: (screenHeight) / 2 - 20,
                  color: customBlueAccent,
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      return ServiceWidget('key', _services[index]);
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Show Rooms'))
          ],
        ),
      ),
    );
  }
}
