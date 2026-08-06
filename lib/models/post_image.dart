class PostImage {
  final int id;
  final int postId;
  final String imageUrl;

  PostImage({required this.id, required this.postId, required this.imageUrl});

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      id: json['id'],
      postId: json['post_id'],
      imageUrl: json['image_url'],
    );
  }
}
