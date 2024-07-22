import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'top-posts.dart';
import 'shared_pref_util.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Post> posts = [];
  bool isLoading = false;

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? storedToken = await SharedPreferencesUtil.getToken();
      print('Token Retrieved: $storedToken');
      final response = await http.get(
        Uri.parse('https://contrary-tar-senators-kelkoo.trycloudflare.com/top-posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        // Log the response for debugging
        print('Response body: ${response.body}');
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          posts = responseData.map((data) => Post.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
        print('Failed to load posts: ${response.reasonPhrase}');
        throw Exception('Failed to load posts');
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
    // Load data after 2 seconds delay
    Future.delayed(Duration(seconds: 0), () {
      _loadData();
    });
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
            // Vertical Grid of Images
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[300],
                    child: posts[index].avatar != null
                        ? Image.memory(
                      base64Decode(posts[index].avatar!),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
