import 'package:flutter/material.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/providers/comment_provider.dart';
import 'package:flutter_app/widgets/comment_list.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final commentController = TextEditingController();
  @override
  void initState() {
    super.initState();

    debugPrint('========== POST DETAIL INIT ==========');
    debugPrint('Post ID: ${widget.post.id}');
    debugPrint('Post title: ${widget.post.title}');
    debugPrint('======================================');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('========== LOADING COMMENTS ==========');
      debugPrint('Requesting comments for Post ID: ${widget.post.id}');

      final commentProvider = context.read<CommentProvider>();

      debugPrint(
        'Comments currently in provider: ${commentProvider.comments.length}',
      );

      await commentProvider.loadComments(widget.post.id);

      debugPrint('========== COMMENTS LOADED ==========');
      debugPrint('Total comments found: ${commentProvider.comments.length}');

      if (commentProvider.comments.isEmpty) {
        debugPrint('⚠️ NO COMMENTS FOUND FOR THIS POST');
      } else {
        debugPrint('✅ ${commentProvider.comments.length} COMMENT(S) FOUND');

        for (int i = 0; i < commentProvider.comments.length; i++) {
          final comment = commentProvider.comments[i];

          debugPrint(
            'Comment #${i + 1}: '
            'ID=${comment.id}, '
            'Content="${comment.content}"',
          );
        }
      }

      debugPrint('====================================');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Post Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(widget.post.title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(widget.post.content, style: const TextStyle(fontSize: 16)),
            if (widget.post.imageUrls.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: widget.post.imageUrls.length,
                  itemBuilder: (context, index) {
                    final image = widget.post.imageUrls[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          image.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text('Unable to load image'),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            Expanded(child: CommentList()),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      final CommentProvider commentProvider =
                          Provider.of<CommentProvider>(context, listen: false);
                      final success = await commentProvider.createComment(
                        postId: widget.post.id,
                        content: commentController.text,
                      );
                      if (success) {
                        commentController.clear();
                        debugPrint('Comment added successfully!');
                      } else {
                        debugPrint(
                          'Failed to add comment: ${commentProvider.errorMessage}',
                        );
                        debugPrint(
                          'Stack trace: ${commentProvider.stackTrace}',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
