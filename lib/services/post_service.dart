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
}
