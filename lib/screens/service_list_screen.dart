import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'owner_panel_screen.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  // TODO: Here we want to fetch services that the user already has
  List<Service> services = [
    Service(name: 'Gym', price: 100.0),
    Service(name: 'Cinema hall', price: 150.0),
    Service(name: 'SPA', price: 250.0),
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
                'Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: buildServiceList(),
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

  Widget buildServiceList() {
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        return buildServiceTile(services[index]);
      },
    );
  }

  Widget buildServiceTile(Service service) {
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
                width: 150,
                child: TextFormField(
                  initialValue: service.name,
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Service Name',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      service.name = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: service.price.toString(),
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
                      service.price = double.tryParse(value) ?? 0.0;
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
    for (var service in services) {
      //print('Service Name: ${service.name}, Price: ${service.price}');
      //TODO: Add database update logic here
    }
  }
}

class Service {
  String name;
  double price;

  Service({required this.name, required this.price});
}
