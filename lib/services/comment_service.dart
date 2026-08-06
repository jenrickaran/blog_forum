import 'package:flutter/material.dart';
import 'package:flutter_app/models/comment.dart';
import 'package:flutter_app/models/comment_image.dart';
import 'package:flutter_app/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentService {
  final SupabaseClient supabase = Supabase.instance.client;
  final StorageService _storageService = StorageService();

  Future<List<Comment>> getComments(int postId) async {
    try {
      final response = await supabase
          .from('comments')
          .select('''
            *,
            comment_images(*)
          ''')
          .eq('post_id', postId)
          .order('created_at');

      final comments = response.map<Comment>((json) {
        return Comment.fromJson(json);
      }).toList();

      return comments;
    } on PostgrestException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createComment({
    required int postId,
    required String content,
    List<XFile> images = const [],
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final response = await supabase
        .from('comments')
        .insert({'post_id': postId, 'user_id': user.id, 'content': content})
        .select()
        .single();

    final commentId = response['id'];

    for (final image in images) {
      final imageUrl = await _storageService.uploadCommentImage([image]);

      await supabase.from('comment_images').insert({
        'comment_id': commentId,
        'image_url': imageUrl,
      });
    }
  }

  Future<void> updateComment({
    required int commentId,
    required String content,
    required List<CommentImage> existingImages,
    List<XFile> newImages = const [],
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    // Get existing images
    final dbImages = await supabase
        .from('comment_images')
        .select()
        .eq('comment_id', commentId);

    // Update comment
    await supabase
        .from('comments')
        .update({
          'content': content,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', commentId);

    // Delete removed images
    for (final dbImage in dbImages) {
      final imageUrl = dbImage['image_url'] as String;

      final stillExists = existingImages.any((img) => img.imageUrl == imageUrl);

      if (!stillExists) {
        final path = Uri.parse(imageUrl).pathSegments.last;

        try {
          await supabase.storage.from('comment-images').remove([path]);

          await supabase
              .from('comment_images')
              .delete()
              .eq('id', dbImage['id'])
              .select();

          debugPrint("Deleted image: $path");
        } catch (e) {
          debugPrint("Failed to delete image: $e");
        }
      }
    }

    // Upload newly added images
    for (final image in newImages) {
      final imageUrl = await _storageService.uploadCommentImage([image]);

      await supabase.from('comment_images').insert({
        'comment_id': commentId,
        'image_url': imageUrl,
      });
    }
  }

  Future<void> deleteComment(int commentId) async {
    // Get comment images
    final images = await supabase
        .from('comment_images')
        .select()
        .eq('comment_id', commentId);

    for (final image in images) {
      final imageUrl = image['image_url'] as String;

      final path = Uri.parse(imageUrl).pathSegments.last;

      await supabase.storage.from('comment-images').remove([path]);
    }

    await supabase.from('comment_images').delete().eq('comment_id', commentId);

    await supabase.from('comments').delete().eq('id', commentId);
  }
}
