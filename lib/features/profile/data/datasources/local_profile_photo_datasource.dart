import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalProfilePhotoDataSource {
  static const _photoKey = 'userPhotoPath';
  static const _updatedAtKey = 'userPhotoUpdatedAt';

  Future<String> save(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final target = File('${dir.path}/user_profile_photo.jpg');
    await image.copy(target.path);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photoKey, target.path);
    await prefs.setInt(_updatedAtKey, DateTime.now().millisecondsSinceEpoch);
    return target.path;
  }

  Future<String?> getSavedPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoKey);
  }

  Future<DateTime?> getUpdatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_updatedAtKey);
    return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
  }

  Future<bool> remove() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_photoKey);
    if (path == null) return false;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // não falhar criticamente no delete do arquivo
    }
    await prefs.remove(_photoKey);
    await prefs.remove(_updatedAtKey);
    return true;
  }
}