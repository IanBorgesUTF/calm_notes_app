import 'dart:io';
import 'package:calm_notes_app/models/note.dart';
import 'package:calm_notes_app/pages/profile_drawer/profile_drawer.dart';
import 'package:calm_notes_app/services/profile_photo/profile_photo_service.dart';
import 'package:calm_notes_app/services/storage/storage_service.dart';
import 'package:flutter/material.dart';

import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/theme.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onNext});
  final VoidCallback? onNext;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final StorageService storageService = StorageService();
  final ProfilePhotoService photoService = ProfilePhotoService();

  List<Note> notes = [];
  String? userPhotoPath;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
    loadPhoto();
  }

  Future<void> loadNotes() async {
    final loaded = await storageService.loadNotes();
    setState(() {
      notes = loaded;
      loading = false;
    });
  }

  Future<void> loadPhoto() async {
    final path = await photoService.getSavedPhotoPath();
    setState(() => userPhotoPath = path);
  }

  void openEditor([String? id]) {
    Navigator.of(context)
        .pushNamed(Routes.editorPage, arguments: {'id': id})
        .then((_) => loadNotes());
  }

  /// abre o Drawer de perfil
  void openProfileDrawer() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: ProfileDrawer(
              userPhotoPath: userPhotoPath,
              onPhotoUpdated: loadPhoto,
              onPhotoRemoved: loadPhoto,
            ),
          ),
        ),
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CalmNotes')),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: slate ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: openProfileDrawer,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[700],
                      backgroundImage: userPhotoPath != null
                          ? FileImage(File(userPhotoPath!))
                          : null,
                      child: userPhotoPath == null
                          ? const Icon(Icons.person,
                              color: Colors.white, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Usuário',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                
                ],
              ),
            ),
            ListTile(

              leading: const Icon(Icons.note, color: Colors.white),
              title:
                  const Text('Notas', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma nota encontrada.\nToque no + para criar uma nova.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (_, i) {
                    final n = notes[i];
                    return ListTile(
                      title:
                          Text(n.title, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(n.tags.join(', '),
                          style: const TextStyle(color: Colors.white70)),
                      onTap: () => openEditor(n.id),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mint,
        child: const Icon(Icons.add),
        onPressed: () => openEditor(),
      ),
    );
  }
}