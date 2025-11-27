import 'dart:io';
import '../../domain/repositories/profile_photo_repository.dart';

class SaveProfilePhotoUseCase {
  final ProfilePhotoRepository repository;
  SaveProfilePhotoUseCase(this.repository);

  Future<String> call(File image) => repository.save(image);

  Future<String> callDataUrl(String dataUrl) => repository.saveDataUrl(dataUrl);
}