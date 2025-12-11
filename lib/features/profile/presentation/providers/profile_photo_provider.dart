import 'dart:convert';
import 'dart:io';
import 'package:calm_notes_app/features/profile/domain/usecases/get_profile_photo_path_usecase.dart';
import 'package:calm_notes_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:calm_notes_app/features/profile/domain/usecases/remove_profile_photo_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/save_profile_photo_usecase.dart';

class ProfilePhotoProvider extends ChangeNotifier {
  final SaveProfilePhotoUseCase saveUseCase;
  final RemoveProfilePhotoUseCase removeUseCase;
  final GetProfilePhotoPathUseCase getPathUseCase;
  final GetUserProfileUseCase getUserUseCase;
  final ImagePicker _picker = ImagePicker();

  String? photoPath;
  DateTime? updatedAt;
  String? userName;
  bool loading = false;

  ProfilePhotoProvider({
    required this.saveUseCase,
    required this.removeUseCase,
    required this.getPathUseCase,
    required this.getUserUseCase,
  });

  Future<void> loadSaved() async {
    photoPath = await getPathUseCase.call();
    updatedAt = await getPathUseCase.getUpdatedAt();
    notifyListeners();
  }

  Future<bool> pickAndSavePhoto(BuildContext context) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final source = await _selectSource(context, colors);
    if (source == null) return false;

    final XFile? picked = await _picker.pickImage(source: source);
    if (picked == null) return false;

    bool confirmed;
    if (!context.mounted) return false;

    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      final previewImage = MemoryImage(Uint8List.fromList(bytes));
      if (!context.mounted) return false;
      confirmed = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: colors.surface,
              title: Text('Confirmar foto', style: TextStyle(color: colors.onSurface)),
              content: Image(image: previewImage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancelar', style: TextStyle(color: colors.primary)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                  child: Text('Confirmar', style: TextStyle(color: colors.onPrimary)),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      confirmed = await _showPreview(context, File(picked.path), colors);
    }

    if (confirmed != true) return false;

    loading = true;
    notifyListeners();

    try {
      String savedPath;
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        final dataUrl = 'data:image/png;base64,${base64Encode(bytes)}';
        savedPath = await saveUseCase.callDataUrl(dataUrl);
      } else {
        savedPath = await saveUseCase.call(File(picked.path));
      }
      photoPath = savedPath;
      updatedAt = DateTime.now();
      return true;
    } catch (e) {
      return false;
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

  Future<ImageSource?> _selectSource(BuildContext context, ColorScheme colors) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('Selecionar imagem', style: TextStyle(color: colors.onSurface)),
        content: Text('De onde deseja obter a foto?', style: TextStyle(color: colors.onSurfaceVariant)),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.photo_camera, color: colors.primary),
            label: Text('Câmera', style: TextStyle(color: colors.primary)),
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          TextButton.icon(
            icon: Icon(Icons.photo_library, color: colors.primary),
            label: Text('Galeria', style: TextStyle(color: colors.primary)),
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<bool> _showPreview(BuildContext context, File image, ColorScheme colors) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: colors.surface,
            title: Text('Confirmar foto', style: TextStyle(color: colors.onSurface)),
            content: Image.file(image, fit: BoxFit.cover),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancelar', style: TextStyle(color: colors.primary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Salvar', style: TextStyle(color: colors.onPrimary)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> loadProfile(String userId) async {
    try {
      final user = await getUserUseCase.call(userId);
      userName = user?.name;
      notifyListeners();
    } catch (_) {}
  }
}
