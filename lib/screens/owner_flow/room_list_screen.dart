import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/services/room_service.dart';
import '../../services/hotel_service.dart';
import '../../services/user_service.dart';
import '../../utils/Utils.dart';
import 'owner_panel_screen.dart';

class RoomListScreen extends StatefulWidget {
  final String hotelID;

  const RoomListScreen(this.hotelID, {super.key});

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late String hotelID;
  final RoomService _roomService = RoomService();
  late List<Room> rooms = [];


  @override
  void initState() {
    super.initState();
    hotelID = widget.hotelID;
    _getRooms();
  }
  Future<void> _getRooms() async {
    final temp = await _roomService.getRoomsByHotelId(hotelID);
    if (temp == null) return;
    setState(() {
      rooms =  temp;
    });
  }

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
                onPressed: () { // TODO: ADD NEW ROOM
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
                  //updateDatabase();
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
    TextEditingController numberController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController availabilityController = TextEditingController();
    numberController.text = room.number.toString();
    priceController.text = room.price.toString();
    typeController.text = room.type.toString();
    availabilityController.text = room.availability.toString();

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
                  controller: typeController,
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
                  controller: priceController,
                ),
              ),
              SizedBox(
                width: 70,
                child: TextFormField(
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Room nr',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  controller: numberController,
                ),
              ),
              SizedBox(
                width: 80,
                child: DropdownButtonFormField(
                  value: room.availability.toString(),
                  items: const [
                    DropdownMenuItem(
                      value: 'true',
                      child: Text('True'),
                    ),
                    DropdownMenuItem(
                      value: 'false',
                      child: Text('False'),
                    ),
                  ],
                  onChanged: (value) {
                    availabilityController.text = value!;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Availability',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: TextFormField(
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  controller: priceController,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  updateDatabase(
                      room.number,
                      int.tryParse(numberController.text) ?? 0,
                      double.tryParse(priceController.text) ?? 0.0,
                      typeController.text,
                      bool.tryParse(availabilityController.text) ?? false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  // TODO: implement adding rooms
  Future<void> updateDatabase(int oldNumber, int newNumber, double price,
      String type, bool availability) async {

    String? roomId = await _roomService.getRoomKeyByNumber(oldNumber.toString());

    Room? oldRoom = await _roomService.getRoomById(roomId!);
    if (oldRoom == null) {
      showToast("Something went wrong");
    } else {
      oldRoom.number = newNumber;
      oldRoom.availability = availability;
      oldRoom.type = type;
      oldRoom.price = price;
      await _roomService.updateRoom(roomId, oldRoom);
      _getRooms();
    }
  }
}
