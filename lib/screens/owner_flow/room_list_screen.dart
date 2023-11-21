import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/room_model.dart';
import 'package:hotel_manager/services/room_service.dart';
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
  TextEditingController numberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController availabilityController = TextEditingController();

  void _showAddRoomModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Number'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 60,
                child: PopupMenuButton<String>(
                  initialValue: "false",
                  onSelected: (String value) {
                    availabilityController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'true',
                        child: Text('True'),
                      ),
                      const PopupMenuItem(
                        value: 'false',
                        child: Text('False'),
                      ),
                    ];
                  },
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      labelText: 'Availability',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                    ),
                    controller: availabilityController,
                    enabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addNewRoom(
                      int.tryParse(numberController.text) ?? 0,
                      int.tryParse(priceController.text) ?? 0,
                      typeController.text,
                      bool.tryParse(availabilityController.text) ?? false);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

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
      rooms = temp;
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
                onPressed: _showAddRoomModal,
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
    TextEditingController numberControl = TextEditingController();
    TextEditingController priceControl = TextEditingController();
    TextEditingController typeControl = TextEditingController();
    TextEditingController availabilityControl = TextEditingController();
    numberControl.text = room.number.toString();
    priceControl.text = room.price.toString();
    typeControl.text = room.type.toString();
    availabilityControl.text = room.availability.toString();
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 1.0),
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
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  controller: typeControl,
                ),
              ),
              SizedBox(
                width: 55,
                child: TextFormField(
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  controller: priceControl,
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Room nr',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  controller: numberControl,
                ),
              ),
              SizedBox(
                width: 60,
                child: PopupMenuButton<String>(
                  initialValue: room.availability.toString(),
                  onSelected: (String value) {
                    availabilityControl.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'true',
                        child: Text('True'),
                      ),
                      const PopupMenuItem(
                        value: 'false',
                        child: Text('False'),
                      ),
                    ];
                  },
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      labelText: 'Availability',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                    ),
                    controller: availabilityControl,
                    enabled: false,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  updateRoom(
                    room.number,
                    int.tryParse(numberControl.text) ?? 0,
                    int.tryParse(priceControl.text) ?? 0,
                    typeControl.text,
                    bool.tryParse(availabilityControl.text) ?? false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addNewRoom(
      int number, int price, String type, bool availability) async {
    final room = await _roomService.getRoomByNumber(number);
    if (room != null) {
      showToast("Room already added or number already picked");
      return;
    }
    Room newRoom = Room(hotelID, type, price, number, availability);
    await _roomService.addRoom(newRoom);
    showToast("New room added");
    rooms.add(newRoom);
    setState(() {
      rooms = rooms;
    });
  }

  Future<void> updateRoom(int oldNumber, int newNumber, int price, String type,
      bool availability) async {
    final room = await _roomService.getRoomByNumber(newNumber);
    if (room != null && room.number != oldNumber) {
      showToast("Number already picked");
      return;
    }
    String? roomId = await _roomService.getRoomKeyByNumber(oldNumber);
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
