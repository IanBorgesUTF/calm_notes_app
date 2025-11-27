import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDataSource {
  final SupabaseClient client = Supabase.instance.client;

  /// cria usuário no Auth e retorna userId
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    final res = await client.auth.signUp(email: email, password: password);
    final user = res.user;
    if (user == null) throw Exception('Falha ao criar usuário');
    return user.id;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> insertProfile({
    required String userId,
    required String name,
    required String email,
    required String phone,
  }) async {
 try {
      final response = await client
          .from('user')
          .insert({
            'id': userId,
            'name': name,
            'email': email,
            'phone_number': phone,
          })
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception(
            'Falha ao inserir perfil do usuário — resposta vazia. Verifique RLS/policies e permissões.');
      }
    } catch (e) {
      throw Exception('Falha ao inserir perfil do usuário: $e');
    }

   }
}