import '../../domain/repositories/profile_photo_repository.dart';

class RemoveProfilePhotoUseCase {
  final ProfilePhotoRepository repository;
  RemoveProfilePhotoUseCase(this.repository);

  Future<bool> call() => repository.remove();
}