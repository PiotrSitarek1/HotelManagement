import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/utils/Utils.dart';
import '../models/service_model.dart';
import '../services/hotel_service.dart';
import 'owner_panel_screen.dart';

class ServiceListScreen extends StatefulWidget {
  final String hotelID;

  const ServiceListScreen(this.hotelID, {super.key});

  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  late String hotelID;
  final HotelService _hotelService = HotelService();
  late List<Service> services = [];
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();

  void _showAddServiceModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serviceNameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _servicePriceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Service Price'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addNewService(_serviceNameController.text,
                      int.tryParse(_servicePriceController.text) ?? 0);
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
    _getHotelServices();
  }

  Future<void> _getHotelServices() async {
    final temp = await _hotelService.getServicesByHotelId(hotelID);
    if (temp == null) return;
    setState(() {
      services = temp;
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
              const SizedBox(height: 10), // Adjust the spacing as needed
              ElevatedButton(
                onPressed: _showAddServiceModal,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
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
                      'PLUS',
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
        return buildServiceTile(services[index], services[index].name);
      },
    );
  }

  Widget buildServiceTile(Service service, String serviceName) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    nameController.text = service.name;
    priceController.text = service.price.toString();
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
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    labelText: 'Service Name',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  controller: nameController,
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
                  _updateService(
                    serviceName,
                    nameController.text,
                    int.tryParse(priceController.text) ?? 0,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addNewService(String serviceName, int servicePrice) async {
    final service =
        await _hotelService.getServiceByHotelIdAndName(hotelID, serviceName);
    if (service != null) {
      showToast("Service already added");
      return;
    }
    Service newService = Service(serviceName, servicePrice);
    await _hotelService.addService(hotelID, newService);
    showToast("New service added");
    services.add(newService);
    setState(() {
      services = services;
    });
  }

  Future<void> _updateService(
      String oldServiceName, String serviceName, int servicePrice) async {
    String? serviceId = await _hotelService.getServiceKeyByHotelIdAndName(
        hotelID, oldServiceName);
    if (serviceId == null) {
      showToast("Something went wrong");
    } else {
      Service? oldService = await _hotelService.getServiceByHotelIdAndServiceId(
          hotelID, serviceId);
      if (oldService == null) {
        showToast("Something went wrong");
      } else {
        oldService.price = servicePrice;
        oldService.name = serviceName;
        await _hotelService.updateService(hotelID, serviceId, oldService);
        _getHotelServices();
      }
    }
  }
}
