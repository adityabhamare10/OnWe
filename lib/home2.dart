import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'shared_pref_util.dart';
import 'widgets/post_item.dart'; // Import your PostItem widget
// import 'add_post_screen.dart'; // Import your AddPostScreen widget

// Define your constants
const String baseUrl = 'https://impossible-wr-mortgage-kg.trycloudflare.com';
const String postsEndpoint = '$baseUrl/mobile/posts';

class Home2Screen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home2Screen> {
  int _selectedIndex = 0;
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final String? token = await SharedPreferencesUtil.getToken();
    print('Stored Retrieved: $token');
    final url = Uri.parse(postsEndpoint);
    try {
      final response = await http.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = json.decode(response.body);
        print('Home Response Received'+response.body);
        setState(() {
          posts = fetchedPosts;
          isLoading = false;
        });
      } else {
        print('Failed to load posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading posts: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OnWe'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
          // IconButton(
            // icon: Icon(Icons.add),
            // onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AddPostScreen()),
              // );
            // },
          // ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostItem(
              postId: post['id'].toString(),
              username: post['username'] ?? 'Unknown',
              time: post['created_at'] ?? '',
              content: post['description'] ?? '',
              initialLikes: post['likes'] ?? 0,
              initialComments: post['comments'] ?? 0,
              base64Images: List<String>.from(post['media'] ?? []),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.black),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Search delegate
class CustomSearchDelegate extends SearchDelegate {
  final List<String> accounts = ['mania.90', 'dharamveer.s', 'thhorest'];
  final List<String> content = [
    'I’m thinking of meet up...',
    'Publisher is the creative software you\'ve been dreaming about...',
    'Inside the campus'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> results = accounts
        .where((account) => account.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final List<String> contentResults = content
        .where((post) => post.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: [
        ...results.map((account) => ListTile(
          title: Text(account),
          onTap: () {
            close(context, null);
          },
        )),
        ...contentResults.map((post) => ListTile(
          title: Text(post),
          onTap: () {
            close(context, null);
          },
        )),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = accounts
        .where((account) => account.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: suggestions
          .map((account) => ListTile(
        title: Text(account),
        onTap: () {
          query = account;
          showResults(context);
        },
      ))
          .toList(),
    );
  }
}
