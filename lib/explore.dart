import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'top-posts.dart';

// Model to hold post data
// class Post {
//   final int id;
//   final String? avatar;
//
//   Post({
//     required this.id,
//     this.avatar,
//   });
//
//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['id'],
//       avatar: json['avatar'],
//     );
//   }
// }

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
      final response = await http.get(
        Uri.parse('https://jersey-tracy-automation-closing.trycloudflare.com/top-posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsImNhdCI6ImNsX0I3ZDRQRDIyMkFBQSIsImtpZCI6Imluc18yaUJIdFRWSEN5NDh3YXV6c2t4emNtQ0o1SE4iLCJ0eXAiOiJKV1QifQ.eyJhenAiOiJodHRwOi8vbG9jYWxob3N0OjMwMDAiLCJleHAiOjE3MjEzMTY3MTAsImhlYWRlciI6eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9LCJpYXQiOjE3MjEyODA3MTAsImlzcyI6Imh0dHBzOi8vd29uZHJvdXMtZ2hvdWwtNzYuY2xlcmsuYWNjb3VudHMuZGV2IiwianRpIjoiNWIzMTdlMGEzZTRmOWQ4YmE5MDciLCJuYmYiOjE3MjEyODA3MDUsInBheWxvYWQiOnsiYXpwIjoibG9jYWxob3N0OjMwMDAiLCJlbWFpbCI6InN1bmRhcmFtZHdpdmVkaTIwMDNAZ21haWwuY29tIiwiZXhwIjoxLjU5NzI2MDg4NWUrMDksImlhdCI6MS41OTcyNTcyODVlKzA5LCJpc3MiOiJodHRwczovL3dvbmRyb3VzLWdob3VsLTc2LmNsZXJrLmFjY291bnRzLmRldiIsInN1YiI6InVzZXItaWQiLCJ1c2VySWQiOiJ1c2VyXzJqSzd0VExLck82ZW1BOXJPTjBmeTVKdW5rdyIsInVzZXJOYW1lIjoic3VuZGFyYW1fMDgifSwic3ViIjoidXNlcl8yaks3dFRMS3JPNmVtQTlyT04wZnk1SnVua3cifQ.tGnvJqRnmTzhAcRqWfV_ERw4ZVj2IruYrLCp_RLjr3G2n1WU76wCykgPfKZRIpQKP8fe4iPVRCmpekDtqiSE93jC5v9FFOKoZASKDY1m3bzvJQ8dMCiV63_mT50ype607Y94iJzK20LLrkA64aGYDXscbOrBYkp0yykuRm_YAMAWl88M2eGrzS4msq6wvC1BGgw3p4bXb-OcsBoV2znWIn3p8dKUy7Zrza7w2brIvdBLBBV6UGgG67XNQBOU9xvp-WWbMYuzbDfBN1sveEnbsS6qF-XNyzNoXO3XFmcfgtoKf4n4h3ZW7rRg3Oe-I3ywIrc7iyH3yFa78TZxc1DCqQ'
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
