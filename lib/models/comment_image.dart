class CommentImage {
  final int id;
  final int commentId;
  final String imageUrl;
  final DateTime createdAt;

  CommentImage({
    required this.id,
    required this.commentId,
    required this.imageUrl,
    required this.createdAt,
  });

  factory CommentImage.fromJson(Map<String, dynamic> json) {
    return CommentImage(
      id: json['id'],
      commentId: json['comment_id'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
