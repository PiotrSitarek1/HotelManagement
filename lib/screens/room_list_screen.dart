import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'owner_panel_screen.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  // TODO: Here we want to fetch rooms that user already has
  List<Room> rooms = [
    Room(type: 'Standard', price: 100.0, roomNumber: 101, availability: true),
    Room(type: 'Deluxe', price: 150.0, roomNumber: 201, availability: true),
    Room(type: 'Suite', price: 250.0, roomNumber: 301, availability: false),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Rooms',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: buildRoomList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    rooms.add(Room(
                        type: 'New Room',
                        price: 0.0,
                        roomNumber: 0,
                        availability: true));
                  });
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: 190,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 8),
                        Text(
                          'Add New Room',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  updateDatabase();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OwnerPanelScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: 150,
                  child: Center(
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRoomList() {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return buildRoomTile(rooms[index]);
      },
    );
  }

  Widget buildRoomTile(Room room) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white.withOpacity(0.9),
        child: ListTile(
          title: Row(
            children: [
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: room.type,
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      room.type = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: room.price.toString(),
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      room.price = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 70,
                child: TextFormField(
                  initialValue: room.roomNumber.toString(),
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Room nr',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      room.roomNumber = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: room.availability.toString(),
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Availability',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      room.availability = value.toLowerCase() == 'true';
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateDatabase() {
    for (var room in rooms) {
      //print('Room Name: ${room.name}, Quantity: ${room.quantity}, Cost: ${room.cost}');
      //TODO: Add database update logic here
    }
  }
}

class Room {
  String type;
  double price;
  int roomNumber;
  bool availability;

  Room({
    required this.type,
    required this.price,
    required this.roomNumber,
    required this.availability,
  });
}
