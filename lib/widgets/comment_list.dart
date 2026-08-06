import 'package:flutter/material.dart';
import 'package:flutter_app/providers/comment_provider.dart';
import 'package:flutter_app/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (_, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.comments.isEmpty) {
          return const Center(
            child: Text("No comments yet."),
          );
        }

        return ListView.builder(
          itemCount: provider.comments.length,
          itemBuilder: (_, index) {
            final comment = provider.comments[index];

            return CommentCard(
              comment: comment,
            );
          },
        );
      },
    );
  }
}