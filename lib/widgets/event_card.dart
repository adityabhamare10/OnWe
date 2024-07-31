import 'package:flutter/material.dart';
import 'package:flutter_project1/models/event.dart';
// import 'event_screen_detail.dart';

class EventCard extends StatefulWidget {
  final Event event;

  EventCard({required this.event});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text(
          widget.event.title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold, // Bold text
            fontSize: screenWidth > 600
                ? 18
                : 14, // Adjust font size based on screen width
          ),
        ),
        SizedBox(height: 8), // Space between title and image
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EventDetailScreen(event: widget.event),
            //   ),
            // );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(widget.event.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            height: screenWidth > 600
                ? 200
                : 142.5, // Adjust height based on screen width
            child: Stack(
              children: [
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'JUN\n24\n08 pm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth > 600
                            ? 14
                            : 12, // Adjust font size based on screen width
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.3), // Overflow content
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.event.isReminderSet = !widget.event.isReminderSet;
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor:
                widget.event.isReminderSet ? Colors.white : Colors.black,
            backgroundColor:
                widget.event.isReminderSet ? Colors.grey : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Good curved edges
            ),
          ),
          child: Text(widget.event.isReminderSet ? 'reminder' : '+ remind'),
        ),
      ],
    );
  }
}
