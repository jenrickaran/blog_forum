import 'package:flutter/material.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/models/post_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  Future<void> createPost({
    required String title,
    required String content,
    List<XFile> images = const [],
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    final response = await Supabase.instance.client
        .from('post')
        .insert({'user_id': user!.id, 'title': title, 'context': content})
        .select()
        .single();

    final postId = response['id'];

    for (final image in images) {
      final imageUrl = await StorageService().uploadImage([image]);

      await Supabase.instance.client.from('post_images').insert({
        'post_id': postId,
        'image_url': imageUrl,
      });
    }
  }

  Future<List<Post>> fetchPosts({required int from, required int to}) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('post')
        .select('''
        id,
        user_id,
        title,
        context,
        created_at,
        post_images (
          id,
          post_id,
          image_url,
          created_at
        )
      ''')
        .order('created_at', ascending: false)
        .range(from, to);

    final userIds = response
        .map<String>((post) => post['user_id'] as String)
        .toSet()
        .toList();

    final profiles = userIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await supabase
              .from('profile')
              .select('id, name, profile_photo')
              .inFilter('id', userIds);

    final profileMap = {for (final profile in profiles) profile['id']: profile};

    return response.map<Post>((json) {
      final profile = profileMap[json['user_id']];

      return Post.fromJson({...json, 'profile': profile});
    }).toList();
  }

  Future<void> deletePost(int postId) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Login first to delete the post.');
    }

    try {
      // 1. Check post and ownership
      final post = await supabase
          .from('post')
          .select('user_id')
          .eq('id', postId)
          .maybeSingle();

      if (post == null) {
        throw Exception('Post not found.');
      }

      final postOwnerId = post['user_id'];

      if (postOwnerId != user.id) {
        throw Exception('You are not authorized to delete this post.');
      }

      // 2. Delete post images
      await supabase.from('post_images').delete().eq('post_id', postId);

      // 3. Find comments belonging to the post
      final comments = await supabase
          .from('comments')
          .select('id')
          .eq('post_id', postId);

      // 4. Delete comment images
      for (final comment in comments) {
        final commentId = comment['id'];

        await supabase
            .from('comment_images')
            .delete()
            .eq('comment_id', commentId);
      }

      // 5. Delete comments
      await supabase.from('comments').delete().eq('post_id', postId);

      // 6. Delete post
      final deletedPost = await supabase
          .from('post')
          .delete()
          .eq('id', postId)
          .eq('user_id', user.id)
          .select();

      // 7. Verify deletion
      if (deletedPost.isEmpty) {
        throw Exception('Post could not be deleted.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePost({
    required int postId,
    required String title,
    required String content,
    required List<PostImage> remainingImages,
    required List<XFile> newImages,
  }) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Login first to update the post.');
    }

    // Check ownership
    final post = await supabase
        .from('post')
        .select('user_id')
        .eq('id', postId)
        .maybeSingle();

    if (post == null) {
      throw Exception('Post not found.');
    }

    if (post['user_id'] != user.id) {
      throw Exception('You are not authorized to update this post.');
    }

    // --------------------------------
    // 1. Update title and content
    // --------------------------------

    await supabase
        .from('post')
        .update({'title': title, 'context': content})
        .eq('id', postId)
        .eq('user_id', user.id);

    // --------------------------------
    // 2. Get current images
    // --------------------------------

    final currentImages = await supabase
        .from('post_images')
        .select('id, image_url')
        .eq('post_id', postId);

    // --------------------------------
    // 3. Determine which images were removed
    // --------------------------------

    final remainingUrls = remainingImages
        .map((image) => image.imageUrl)
        .toSet();

    final removedImages = currentImages.where((image) {
      return !remainingUrls.contains(image['image_url']);
    }).toList();

    // --------------------------------
    // 4. Delete removed images
    // --------------------------------

    for (final image in removedImages) {
      final imageUrl = image['image_url'] as String;

      final path = imageUrl.split('/post-images/').last;

      await supabase.storage.from('post-images').remove([path]);

      await supabase.from('post_images').delete().eq('id', image['id']);
    }

    // --------------------------------
    // 5. Upload newly added images
    // --------------------------------

    for (final image in newImages) {
      final bytes = await image.readAsBytes();

      final extension = image.name.split('.').last;

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

      await supabase.storage.from('post-images').uploadBinary(fileName, bytes);

      final imageUrl = supabase.storage
          .from('post-images')
          .getPublicUrl(fileName);

      await supabase.from('post_images').insert({
        'post_id': postId,
        'image_url': imageUrl,
      });
    }
  }
}
