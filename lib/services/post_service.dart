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
      final imageUrl = await StorageService().uploadImage(image);

      await Supabase.instance.client.from('post_images').insert({
        'post_id': postId,
        'image_url': imageUrl,
      });
    }
  }
}
