import 'dart:io';

abstract class ProfilePhotoRepository {
  Future<String?> getSavedPath();
  Future<DateTime?> getUpdatedAt();
  Future<String> save(File image);
  Future<bool> remove();
  Future<String> saveDataUrl(String dataUrl);
}