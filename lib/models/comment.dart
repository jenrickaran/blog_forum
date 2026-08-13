import 'package:flutter_app/models/comment_image.dart';

class Comment {
  final int id;
  final int postId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String? updatedAt;
  final List<CommentImage> commentImages;
  final String? userName;
  final String? profilePhoto;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.commentImages,
    this.userName,
    this.profilePhoto,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];

    return Comment(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] ?? '',
      commentImages: json['comment_images'] != null
          ? (json['comment_images'] as List<dynamic>)
                .map(
                  (image) =>
                      CommentImage.fromJson(image as Map<String, dynamic>),
                )
                .toList()
          : [],
      userName: profile?['name'],
      profilePhoto: profile?['profile_photo'],
    );
  }
}
