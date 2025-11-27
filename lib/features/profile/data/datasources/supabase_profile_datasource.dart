import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileDataSource {
  final SupabaseClient client = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchUserById(String userId) async {
    final res = await client.from('user').select().eq('id', userId).maybeSingle();
    if (res == null) return null;
    return Map<String, dynamic>.from(res as Map);
  }
}