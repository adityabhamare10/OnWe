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
      media: List<String>.from(json['media']),
    );
  }
}
