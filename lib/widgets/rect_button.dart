import 'package:flutter/material.dart';

class RectButton extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  RectButton({required this.label, required this.onTap, this.isActive = false});

  @override
  _RectButtonState createState() => _RectButtonState();
}

class _RectButtonState extends State<RectButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onHover: (hovering) {
        setState(() {
          _isHovered = hovering;
        });
      },
      onTap: widget.onTap,
      child: Container(
        width:
            screenWidth > 600 ? 120 : 100, // Adjust width based on screen width
        height:
            screenWidth > 600 ? 50 : 40, // Adjust height based on screen width
        decoration: BoxDecoration(
          color: widget.isActive
              ? Colors.black
              : (_isHovered ? Colors.black : Colors.white),
          borderRadius: BorderRadius.circular(12), // Curved edges
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.isActive
                  ? Colors.white
                  : (_isHovered ? Colors.white : Colors.black),
              fontSize: screenWidth > 600
                  ? 16
                  : 14, // Adjust font size based on screen width
            ),
          ),
        ),
      ),
    );
  }
}
