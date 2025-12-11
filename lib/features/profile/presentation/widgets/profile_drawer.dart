import 'package:calm_notes_app/core/image_helper.dart';
import 'package:calm_notes_app/features/profile/presentation/providers/profile_photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDrawer extends StatefulWidget {
  final String? userPhotoPath;
  final VoidCallback onPhotoUpdated;
  final VoidCallback onPhotoRemoved;

  const ProfileDrawer({
    super.key,
    required this.userPhotoPath,
    required this.onPhotoUpdated,
    required this.onPhotoRemoved,
  });

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfilePhotoProvider>(context, listen: false);
      provider.loadSaved().then((_) {
        if (mounted) setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final provider = Provider.of<ProfilePhotoProvider>(context);
    final displayPath = provider.photoPath ?? widget.userPhotoPath;
    final ImageProvider? avatarImage = imageProviderFromPath(displayPath);

    return Drawer(
      backgroundColor: colors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Perfil do Usuário',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: colors.primary.withAlpha(20),
                backgroundImage: avatarImage,
                child: avatarImage == null
                    ? Icon(Icons.person, size: 60, color: colors.onSurface)
                    : null,
              ),
              const SizedBox(height: 10),
              if (provider.updatedAt != null)
                Text(
                  'Atualizada em ${provider.updatedAt!.day}/${provider.updatedAt!.month}/${provider.updatedAt!.year}',
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
                ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.photo_camera, color: colors.onPrimary),
                label: Text('Alterar foto', style: TextStyle(color: colors.onPrimary)),
                style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                onPressed: provider.loading
                    ? null
                    : () async {
                        final ok = await provider.pickAndSavePhoto(context);
                        if (ok) widget.onPhotoUpdated();
                        if (context.mounted) Navigator.pop(context);
                      },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.delete_forever, color: colors.onError),
                label: Text('Remover foto', style: TextStyle(color: colors.onError)),
                style: ElevatedButton.styleFrom(backgroundColor: colors.error),
                onPressed: provider.loading
                    ? null
                    : () async {
                        final ok = await provider.removePhoto(context);
                        if (ok) {
                          widget.onPhotoRemoved();
                          if (context.mounted) Navigator.pop(context);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Falha ao remover foto')),
                            );
                          }
                        }
                      },
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: colors.onSurfaceVariant),
                label: Text('Voltar', style: TextStyle(color: colors.onSurfaceVariant)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
