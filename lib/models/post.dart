import 'package:flutter_app/models/post_image.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String userId;
  final List<PostImage> imageUrls;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.imageUrls,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['context'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      imageUrls: (json['post_images'] as List<dynamic>)
          .map((image) => PostImage.fromJson(image))
          .toList(),
    );
  }
}
