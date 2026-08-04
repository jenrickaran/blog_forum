import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      await _supabase.from('profile').insert({
        'id': _supabase.auth.currentUser!.id,
        'name': '',
        'profile_photo': null,
      });
    }

    return response;
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
