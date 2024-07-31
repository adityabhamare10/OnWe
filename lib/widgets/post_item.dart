import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_project1/comment_screen.dart'; // Import your CommentScreen

// Define your constants
const String baseUrl = 'https://salmon-issue-indoor-karaoke.trycloudflare.com';
const String likeEndpoint = '$baseUrl/posts/like';
const String commentsEndpoint =
    '$baseUrl/posts'; // The base part, will be completed with postId

class PostItem extends StatefulWidget {
  final String postId;
  final String username;
  final String time;
  final String content;
  final int initialLikes;
  final int initialComments;
  final List<String> base64Images; // List of base64 images

  PostItem({
    required this.postId,
    required this.username,
    required this.time,
    required this.content,
    required this.initialLikes,
    required this.initialComments,
    required this.base64Images,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late int likes;
  late int comments;
  bool hasLiked = false; // Track if the user has liked the post
  List<Map<String, String>> commentsList = []; // List to hold comments

  @override
  void initState() {
    super.initState();
    likes = widget.initialLikes;
    comments = widget.initialComments;
    _fetchComments(); // Fetch existing comments from the database
  }

  Future<void> _fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('$commentsEndpoint/${widget.postId}/comments'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          commentsList = data.map<Map<String, String>>((comment) {
            return {
              'username': comment['username'] ?? 'Unknown',
              'comment': comment['comment'] ?? '',
              'time': comment['created_at'] ?? '',
            };
          }).toList();
        });
      } else {
        print('Failed to load comments');
      }
    } catch (error) {
      print('Error fetching comments: $error');
    }
  }

  Future<void> _toggleLike() async {
    final response = hasLiked
        ? await http.delete(
            Uri.parse(likeEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'postId': widget.postId}),
          )
        : await http.post(
            Uri.parse(likeEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'postId': widget.postId}),
          );

    if (response.statusCode == 200) {
      setState(() {
        hasLiked = !hasLiked; // Toggle like status
        likes += hasLiked ? 1 : -1; // Update likes count
      });
    } else {
      print('Failed to update like');
    }
  }

  Future<void> _addComment(String commentText) async {
    final response = await http.post(
      Uri.parse('$commentsEndpoint/${widget.postId}/comments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': widget.username,
        'comment': commentText,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        comments += 1; // Increment comments count
        commentsList.add({
          'username': widget.username,
          'comment': commentText,
          'time': DateFormat('hh:mm a').format(DateTime.now()), // Add timestamp
        });
      });
    } else {
      print('Failed to add comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(widget.username[0].toUpperCase())),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.time),
                  ],
                ),
              ],
            ),
            if (widget.base64Images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    for (var base64Image in widget.base64Images)
                      Image.memory(
                        base64Decode(base64Image),
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(widget.content),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        hasLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                        color: hasLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    ),
                    SizedBox(width: 5),
                    Text('$likes'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              postId: widget.postId,
                              username: widget.username,
                              comments: commentsList,
                            ),
                          ),
                        ).then((value) {
                          if (value != null && value is String) {
                            _addComment(
                                value); // Add comment if returned from CommentScreen
                          } else {
                            _fetchComments(); // Refresh comments after adding
                          }
                        });
                      },
                    ),
                    SizedBox(width: 5),
                    Text('$comments'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
