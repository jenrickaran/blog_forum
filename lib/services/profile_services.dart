import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient supabase = Supabase.instance.client;

  User? get currentUser => supabase.auth.currentUser;

  Future<void> updateName(String name) async {
    final user = currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    await supabase.from('profile').update({'name': name}).eq('id', user.id);
  }

  Future<void> updateEmail(String email) async {
    await supabase.auth.updateUser(UserAttributes(email: email));
  }

  Future<void> updatePassword(String password) async {
    await supabase.auth.updateUser(UserAttributes(password: password));
  }

  Future<String> uploadAvatar(XFile image) async {
    final user = currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final Uint8List bytes = await image.readAsBytes();

    final extension = image.name.split('.').last;
    final path = '${user.id}/avatar.$extension';

    await supabase.storage
        .from('avatars')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final avatarUrl = supabase.storage.from('avatars').getPublicUrl(path);

    await supabase
        .from('profile')
        .update({'profile_photo': avatarUrl})
        .eq('id', user.id);

    return avatarUrl;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;

    if (user == null) return null;

    return await supabase
        .from('profile')
        .select()
        .eq('id', user.id)
        .maybeSingle();
  }
}
