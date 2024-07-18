import 'package:flutter/material.dart';
import 'package:flutter_project1/explore.dart';


class ClubsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clubs'),
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
          ],
        ),
      ),
    );
  }




}