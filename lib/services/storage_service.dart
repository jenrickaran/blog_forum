import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;

  Future<String> uploadImage(XFile image) async {
    final bytes = await image.readAsBytes();

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';

    await supabase.storage
        .from('post-images')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(
            contentType: image.mimeType ?? 'image/jpeg',
            upsert: true,
          ),
        );

    return supabase.storage.from('post-images').getPublicUrl(fileName);
  }
}
