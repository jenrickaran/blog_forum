import 'package:flutter/material.dart';
import 'package:flutter_app/providers/comment_provider.dart';
import 'package:flutter_app/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    return Consumer<CommentProvider>(
      builder: (_, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.comments.isEmpty) {
          return const Center(
            child: Text(
              "No comments yet.",
              style: TextStyle(fontFamily: 'Google-Sans'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.comments.length,
          itemBuilder: (_, index) {
            final comment = provider.comments[index];

            return CommentCard(
              comment: comment,
              isOwner: comment.userId == currentUserId,
              onEdit: (content, existingImages, newImages) async {
                await provider.updateComment(
                  commentId: comment.id,
                  postId: comment.postId,
                  content: content,
                  existingImages: existingImages,
                  newImages: newImages,
                );
              },
              onDelete: () async {
                await provider.deleteComment(
                  commentId: comment.id,
                  postId: comment.postId,
                );
              },
            );
          },
        );
      },
    );
  }
}
