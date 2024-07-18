class Post {
  final int id;
  final String? title;
  final String? description;
  final String? userId;
  final String? avatar;

  Post({
    required this.id,
    this.title,
    this.description,
    this.userId,
    this.avatar,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userid'],
      avatar: json['avatar'],
    );
  }
}