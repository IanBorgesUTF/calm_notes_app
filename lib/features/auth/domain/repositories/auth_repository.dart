abstract class AuthRepository {
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<void> login({
    required String email,
    required String password,
  });
}