// ...existing code...
import 'dart:io';
import '../../domain/repositories/profile_photo_repository.dart';
import '../datasources/local_profile_photo_datasource.dart';

class ProfilePhotoRepositoryImpl implements ProfilePhotoRepository {
  final LocalProfilePhotoDataSource datasource;
  ProfilePhotoRepositoryImpl(this.datasource);

  @override
  Future<String?> getSavedPath() => datasource.getSavedPath();

  @override
  Future<DateTime?> getUpdatedAt() => datasource.getUpdatedAt();

  @override
  Future<String> save(File image) => datasource.save(image);

  @override
  Future<String> saveDataUrl(String dataUrl) => datasource.saveDataUrl(dataUrl);

  @override
  Future<bool> remove() => datasource.remove();
}