import 'package:flutter_app/models/post.dart';
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

    return response.map<Post>((json) => Post.fromJson(json)).toList();
  }

  Future<void> deletePost(int postId) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Login first to delete the post.');
    }

    // 1. Verify that the post belongs to the logged-in user.
    final post = await supabase
        .from('post')
        .select('user_id')
        .eq('id', postId)
        .maybeSingle();

    if (post == null) {
      throw Exception('Post not found.');
    }

    if (post['user_id'] != user.id) {
      throw Exception('You are not authorized to delete this post.');
    }

    // 2. Delete associated image records.
    await supabase.from('post_images').delete().eq('post_id', postId);

    // 3. Delete the post.
    await supabase
        .from('post')
        .delete()
        .eq('id', postId)
        .eq('user_id', user.id);
  }

  Future<void> updatePost({
    required int postId,
    required String title,
    required String content,
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

    // Update the post
    await supabase
        .from('post')
        .update({'title': title, 'context': content})
        .eq('id', postId)
        .eq('user_id', user.id);
  }
}
