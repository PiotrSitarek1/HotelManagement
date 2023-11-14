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
    Room(name: 'Standard', quantity: 10, cost: 100.0),
    Room(name: 'Deluxe', quantity: 5, cost: 150.0),
    Room(name: 'Suite', quantity: 2, cost: 250.0),
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
                  updateDatabase();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OwnerPanelScreen()),
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
                width: 100,
                child: TextFormField(
                  initialValue: room.name,
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      room.name = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 120,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          room.quantity =
                              (room.quantity > 0) ? room.quantity - 1 : 0;
                        });
                      },
                    ),
                    Text('${room.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          room.quantity = room.quantity + 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              SizedBox(
                width: 70,
                child: TextFormField(
                  initialValue: room.cost.toString(),
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Cost',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      room.cost = double.tryParse(value) ?? 0.0;
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
  String name;
  int quantity;
  double cost;

  Room({required this.name, required this.quantity, required this.cost});
}
