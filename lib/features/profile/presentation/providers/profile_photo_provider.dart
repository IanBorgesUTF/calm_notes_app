import 'dart:io';
import 'package:calm_notes_app/features/profile/domain/usecases/get_profile_photo_path_usecase.dart';
import 'package:calm_notes_app/features/profile/domain/usecases/remove_profile_photo_usecase.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/save_profile_photo_usecase.dart';

class ProfilePhotoProvider extends ChangeNotifier {
  final SaveProfilePhotoUseCase saveUseCase;
  final RemoveProfilePhotoUseCase removeUseCase;
  final GetProfilePhotoPathUseCase getPathUseCase;
  final ImagePicker _picker = ImagePicker();

  String? photoPath;
  DateTime? updatedAt;
  bool loading = false;

  ProfilePhotoProvider({
    required this.saveUseCase,
    required this.removeUseCase,
    required this.getPathUseCase,
  });

  Future<void> loadSaved() async {
    photoPath = await getPathUseCase.call();
    updatedAt = await getPathUseCase.getUpdatedAt();
    notifyListeners();
  }

  // UI (context) logic stays here:
  Future<void> pickAndSavePhoto(BuildContext context) async {
    final source = await _selectSource(context);
    if (source == null) return;
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked == null) return;
    if (!context.mounted) return;
    final confirmed = await _showPreview(context, File(picked.path));
    if (!confirmed) return;

    loading = true;
    notifyListeners();
    try {
      final savedPath = await saveUseCase.call(File(picked.path));
      photoPath = savedPath;
    } catch (e) {
      // tratar erro
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> removePhoto(BuildContext context) async {
    loading = true;
    notifyListeners();
    try {
      final ok = await removeUseCase.call();
      if (ok) {
        photoPath = null;
        updatedAt = null;
      }
      loading = false;
      notifyListeners();
      return ok;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
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