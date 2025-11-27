import '../../domain/repositories/profile_photo_repository.dart';

class GetProfilePhotoPathUseCase {
  final ProfilePhotoRepository repository;
  GetProfilePhotoPathUseCase(this.repository);

  Future<String?> call() => repository.getSavedPath();

  Future<DateTime?> getUpdatedAt() => repository.getUpdatedAt();
}