import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User?> getById(String userId);
}