import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;
  GetUserProfileUseCase(this.repository);

  Future<User?> call(String userId) => repository.getById(userId);
}