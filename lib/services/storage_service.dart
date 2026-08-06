import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;

  Future<String> uploadImage(List<XFile> images) async {
    final bytes = await images.first.readAsBytes();
    final extension = images.first.name.split('.').last;

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from('post-images')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(
            contentType: images.first.mimeType ?? 'image/jpeg',
            upsert: true,
          ),
        );

    return supabase.storage.from('post-images').getPublicUrl(fileName);
  }

  Future<String> uploadCommentImage(List<XFile> images) async {
    final bytes = await images.first.readAsBytes();
    final extension = images.first.name.split('.').last;

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from('comment-images')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(
            contentType: images.first.mimeType ?? 'image/jpeg',
            upsert: true,
          ),
        );

    return supabase.storage.from('comment-images').getPublicUrl(fileName);
  }
}
