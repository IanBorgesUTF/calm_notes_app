import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePhotoService {
  static const _photoKey = 'userPhotoPath';
  static const _updatedAtKey = 'userPhotoUpdatedAt';

  final ImagePicker _picker = ImagePicker();

  Future<String?> getSavedPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoKey);
  }

  Future<DateTime?> getPhotoUpdatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_updatedAtKey);
    return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
  }

  Future<String?> pickPhoto(BuildContext context) async {
    final source = await _selectSource(context);
    if (source == null) return null;

    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return null;

    final confirm = await _showPreview(context, File(image.path));
    if (!confirm) return null;

    final dir = await getApplicationDocumentsDirectory();
    final localImage = File('${dir.path}/user_profile_photo.jpg');
    await File(image.path).copy(localImage.path);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photoKey, localImage.path);
    await prefs.setInt(_updatedAtKey, DateTime.now().millisecondsSinceEpoch);

    return localImage.path;
  }

  Future<bool> removePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_photoKey);

    if (path != null) {
      final file = File(path);
      if (await file.exists()) await file.delete();
      await prefs.remove(_photoKey);
      await prefs.remove(_updatedAtKey);
      return true;
    }
    return false;
  }

  Future<ImageSource?> _selectSource(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Selecionar imagem'),
        content: const Text('De onde deseja obter a foto?'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.photo_camera, color: Colors.black,),
            label: const Text('Câmera',style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          TextButton.icon(
            icon: const Icon(Icons.photo_library, color: Colors.black),
            label: const Text('Galeria',style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<bool> _showPreview(BuildContext context, File image) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar foto',style: TextStyle(color: Colors.black),),
            content: Image.file(image, fit: BoxFit.cover),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar',style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Salvar',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ) ??
        false;
  }
}
