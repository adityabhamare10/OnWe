import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'shared_pref_util.dart';

class Post {
  final int id;
  final List<String> media;

  Post({
    required this.id,
    required this.media,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      media: List<String>.from(json['media'] ?? []),
    );
  }
}

class Club {
  final int clubId;
  final String clubName;
  final String coverImage;

  Club({
    required this.clubId,
    required this.clubName,
    required this.coverImage,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    // Assuming coverImage is a list with one element
    String coverImage = (json['coverImage'] as List<dynamic>)[0];
    return Club(
      clubId: json['clubId'],
      clubName: json['clubName'],
      coverImage: coverImage,
    );
  }
}

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Post> posts = [];
  List<Club> clubs = [];
  bool isLoading = false;

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? storedToken = await SharedPreferencesUtil.getToken();
      print('Saved Token: $storedToken');

      // Fetch top clubs
      final clubsResponse = await http.get(
        Uri.parse('https://display-performing-screenshots-caps.trycloudflare.com/mobile/topclubs'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken',
        },
      );

      // Fetch top posts
      final postsResponse = await http.get(
        Uri.parse('https://display-performing-screenshots-caps.trycloudflare.com/mobile/top-posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (clubsResponse.statusCode == 200 && postsResponse.statusCode == 200) {
        // Log the response for debugging
        print('Clubs Response : ${clubsResponse.body}');
        print('Posts Response : ${postsResponse.body}');

        final List<dynamic> clubsData = jsonDecode(clubsResponse.body);
        final List<dynamic> postsData = jsonDecode(postsResponse.body);

        setState(() {
          clubs = clubsData.map((data) => Club.fromJson(data)).toList();
          posts = postsData.map((data) => Post.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
        print('Failed to load data: ${clubsResponse.reasonPhrase}, ${postsResponse.reasonPhrase}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Horizontal list of top clubs
            if (clubs.isNotEmpty)
              Container(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: clubs.length,
                  itemBuilder: (context, index) {
                    final club = clubs[index];
                    return Container(
                      width: 150.0,
                      margin: EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          Image.memory(
                            base64Decode(club.coverImage),
                            width: 100,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          Text(club.clubName),
                        ],
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 16.0),
            // Vertical Grid of Images
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three columns in the grid
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Column(
                    children: List.generate(post.media.length, (mediaIndex) {
                      return Container(
                        color: Colors.grey[300],
                        child: post.media[mediaIndex] != null
                            ? Image.memory(
                          base64Decode(post.media[mediaIndex]),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
