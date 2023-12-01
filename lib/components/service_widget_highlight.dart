import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_manager/models/service_model.dart';

// ignore: must_be_immutable
class ServiceWidgetHighlight extends StatefulWidget {
  final Service service;
  final TappedChange tp;
  bool _checked = false;
  Color _colorContainer = Colors.white.withOpacity(0.9);
  bool get checked => _checked;

  ServiceWidgetHighlight({required this.service, required this.tp, Key? key})
      : super(key: key);

  @override
  _ServiceWidgetHighlight createState() => _ServiceWidgetHighlight();
}

class TappedChange with ChangeNotifier {
  bool _tapped = false;
  bool get tapped => _tapped;
  int _price = 0;
  int get price => _price;
  void _toggletapped() {
    _tapped = !tapped;
    notifyListeners();
    debugPrint('Tapped');
  }

  // void _setPriceOfTapped(int newPrice) {
  //   if (!_tapped) {
  //     newPrice = newPrice * -1;
  //   }
  //   _price = newPrice;
  //   notifyListeners();
  //   debugPrint('new Price set');
  //   print(_price);
  // }

  void _addPrice(int newPrice) {
    _price = newPrice;
    notifyListeners();
  }

  void _subtractPrice(int newPrice) {
    _price = -newPrice;
    notifyListeners();
  }
}

class _ServiceWidgetHighlight extends State<ServiceWidgetHighlight> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: InkWell(
        onTap: () {
          setState(() {
            widget._checked = !widget._checked;
            widget.tp._toggletapped();
            if (widget._checked) {
              widget.tp._addPrice(widget.service.price);
            } else {
              widget.tp._subtractPrice(widget.service.price);
            }

            widget._colorContainer =
                widget._checked ? Colors.green : Colors.white.withOpacity(0.9);
          });
        },
        child: Ink(
          height: 150,
          child: Card(
            color: widget._colorContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
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
