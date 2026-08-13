import 'package:flutter_app/models/post_image.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String userId;
  final List<PostImage> imageUrls;
  final String? userName;
  final String? profilePhoto;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.imageUrls,
    this.userName,
    this.profilePhoto,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['context'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      imageUrls: (json['post_images'] as List<dynamic>)
          .map((image) => PostImage.fromJson(image))
          .toList(),
      userName: profile?['name'],
      profilePhoto: profile?['profile_photo'],
    );
  }

  Post copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    String? userId,
    List<PostImage>? imageUrls,
    String? userName,
    String? profilePhoto,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      imageUrls: imageUrls ?? this.imageUrls,
      userName: userName ?? this.userName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}
