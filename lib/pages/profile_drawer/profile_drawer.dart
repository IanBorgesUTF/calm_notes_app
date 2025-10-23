import 'dart:io';
import 'package:calm_notes_app/services/profile_photo/profile_photo_service.dart';
import 'package:flutter/material.dart';

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
  final ProfilePhotoService photoService = ProfilePhotoService();
  DateTime? updatedAt;

  @override
  void initState() {
    super.initState();
    loadDate();
  }

  Future<void> loadDate() async {
    updatedAt = await photoService.getPhotoUpdatedAt();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Perfil do Usuário',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[700],
                backgroundImage: widget.userPhotoPath != null
                    ? FileImage(File(widget.userPhotoPath!))
                    : null,
                child: widget.userPhotoPath == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 10),
              if (updatedAt != null)
                Text(
                  'Atualizada em ${updatedAt!.day}/${updatedAt!.month}/${updatedAt!.year}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_camera, color: Colors.black),
                label: const Text('Alterar foto',style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  await photoService.pickPhoto(context);
                  widget.onPhotoUpdated();
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                label: const Text('Remover foto', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await photoService.removePhoto();
                  widget.onPhotoRemoved();
                },
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                label: const Text('Voltar',
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
