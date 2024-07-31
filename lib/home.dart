import 'package:flutter/material.dart';
import 'package:flutter_project1/explore.dart';
import 'package:flutter_project1/clubs.dart';
import 'package:flutter_project1/home2.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExploreScreen()),
                );
              },
              child: Text('Go to Explore Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClubsScreen()),
                );
              },
              child: Text('Go to Clubs Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home2Screen()),
                );
              },
              child: Text('Go to Home2 Screen'),
            ),
          ],
        ),
      ),
    );
  }




}