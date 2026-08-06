import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileServices {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile() async {
    final userId = _supabase.auth.currentUser?.id;

    return await _supabase
        .from('profile')
        .select()
        .eq('id', userId!)
        .maybeSingle();
  }
}
