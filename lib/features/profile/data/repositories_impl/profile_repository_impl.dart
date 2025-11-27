import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/supabase_profile_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource datasource;
  ProfileRepositoryImpl(this.datasource);

  @override
  Future<User?> getById(String userId) async {
    final map = await datasource.fetchUserById(userId);
    if (map == null) return null;
    return User.fromMap(map);
  }
}