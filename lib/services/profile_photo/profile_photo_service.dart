import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePhotoService {
  static const _photoKey = 'userPhotoPath';
  static const _updatedAtKey = 'userPhotoUpdatedAt';

  final ImagePicker _picker = ImagePicker();

  /// Carrega o caminho salvo da foto do usuário
  Future<String?> getSavedPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoKey);
  }

  /// Carrega a data de atualização da foto (opcional, para exibir ou sincronizar)
  Future<DateTime?> getPhotoUpdatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_updatedAtKey);
    return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
  }

  /// Permite escolher entre câmera e galeria, com preview antes de salvar
  Future<String?> pickPhoto(BuildContext context) async {
    final source = await _selectSource(context);
    if (source == null) return null;

    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return null;

    // preview antes de salvar
    final confirm = await _showPreview(context, File(image.path));
    if (!confirm) return null;

    // salva no diretório do app
    final dir = await getApplicationDocumentsDirectory();
    final localImage = File('${dir.path}/user_profile_photo.jpg');
    await File(image.path).copy(localImage.path);

    // grava caminho e data no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photoKey, localImage.path);
    await prefs.setInt(_updatedAtKey, DateTime.now().millisecondsSinceEpoch);

    return localImage.path;
  }

  /// Remove a foto salva
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

  /// --- Helpers ---

  /// Escolhe entre câmera e galeria
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

  /// Mostra preview da imagem antes de salvar
  Future<bool> _showPreview(BuildContext context, File image) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar foto'),
            content: Image.file(image, fit: BoxFit.cover),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
