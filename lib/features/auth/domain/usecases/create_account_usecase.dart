import '../repositories/auth_repository.dart';

class CreateAccountUseCase {
  final AuthRepository repository;
  CreateAccountUseCase(this.repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return repository.createUser(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }
}