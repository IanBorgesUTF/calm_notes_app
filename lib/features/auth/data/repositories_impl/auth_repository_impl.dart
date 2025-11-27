import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final userId = await datasource.signUp(email: email, password: password);
    await datasource.signIn(email: email, password: password);
    await datasource.insertProfile(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
    );
  }

  @override
  Future<void> login({ required String email, required String password }) async {
    try {
      final resp = await datasource.signIn(email: email, password: password);
      final user = resp?['user'];
      if (user == null) throw Exception('Falha no login: usuário não encontrado.');
    } catch (e) {
      rethrow;
    }
  }
}