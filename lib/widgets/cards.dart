import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class CardF extends StatefulWidget {
  final String title;
  final String color;
  final String devices;

  const CardF({super.key, required this.title, required this.color, required this.devices});

 
  @override
  _CardFState createState() => _CardFState();
}

class _CardFState extends State<CardF> {
  bool _isHovered = false;
   
  

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    switch (widget.color.toLowerCase()) {
      case 'red':
        cardColor = Color(0xFFff7452)!;
        break;
      case 'yellow':
        cardColor = Color(0xff2684ff)!;
        break;
      case 'blue':
        cardColor = const Color(0xff57d9a3)!;
        break;
      case 'green':
      default:
        cardColor = const Color(0XFFffc400)!;
        break;
    }

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(_isHovered ? 0.9 : 0.87),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.smartphone, color: Colors.white, size: 30),
                  SizedBox(height: 6),
                  Text(
                  widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.devices,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
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
