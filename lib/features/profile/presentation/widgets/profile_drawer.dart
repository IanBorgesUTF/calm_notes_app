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
  DateTime? updatedAt;

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
    final provider = Provider.of<ProfilePhotoProvider>(context);
    final displayPath = provider.photoPath ?? widget.userPhotoPath;
    final ImageProvider? avatarImage = imageProviderFromPath(displayPath);

    

    return Drawer(
      backgroundColor: Colors.grey[800],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Perfil do Usuário', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[700],
                backgroundImage: avatarImage,
                child: avatarImage == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
              ),
              const SizedBox(height: 10),
              if (provider.updatedAt != null)
                Text(
                  'Atualizada em ${provider.updatedAt!.day}/${provider.updatedAt!.month}/${provider.updatedAt!.year}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_camera, color: Colors.black),
                label: const Text('Alterar foto', style: TextStyle(color: Colors.black)),
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
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                label: const Text('Remover foto', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: provider.loading
                    ? null
                    : () async {
                       final ok = await provider.removePhoto(context);
                        if (ok) {
                          widget.onPhotoRemoved();
                          if (context.mounted) Navigator.pop(context);
                        } else {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao remover foto')));
                        }
                      },
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                label: const Text('Voltar', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}