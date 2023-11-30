import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/service_model.dart';

class ServiceWidgetHighlight extends StatefulWidget {
  final Service service;
  const ServiceWidgetHighlight({required this.service, Key? key})
      : super(key: key);

  @override
  _ServiceWidgetHighlight createState() => _ServiceWidgetHighlight();
}

class _ServiceWidgetHighlight extends State<ServiceWidgetHighlight> {
  @override
  Widget build(BuildContext context) {
    bool tapped = false;
    Color _colorContainer = Colors.white.withOpacity(0.9);

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _colorContainer = Colors.amber;
          });
        },
        child: Ink(
          height: 150,
          color: _colorContainer,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: _colorContainer,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Service: ${widget.service.name} ',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' Price: ${widget.service.price}',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
