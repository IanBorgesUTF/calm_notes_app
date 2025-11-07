// lib/pages/home/home.dart
import 'dart:io';
import 'package:calm_notes_app/providers/notes/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../theme.dart';
import '../../pages/profile_drawer/profile_drawer.dart';
import '../../services/profile_photo/profile_photo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ProfilePhotoService photoService = ProfilePhotoService();
  String? userPhotoPath;

  @override
  void initState() {
    super.initState();
    loadPhoto();
    // load notes after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().loadNotes();
    });
  }

  Future<void> loadPhoto() async {
    final path = await photoService.getSavedPhotoPath();
    setState(() => userPhotoPath = path);
  }

  void openEditor([String? id]) {
    Navigator.of(context).pushNamed(Routes.editorPage, arguments: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    final notes = provider.notes;

    return Scaffold(
      appBar: AppBar(title: const Text('CalmNotes')),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: slate),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
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
                            position: Tween(begin: const Offset(-1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                            child: child,
                          );
                        },
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[700],
                      backgroundImage: userPhotoPath != null ? FileImage(File(userPhotoPath!)) : null,
                      child: userPhotoPath == null ? const Icon(Icons.person, color: Colors.white, size: 40) : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Usuário', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.note, color: Colors.white),
              title: const Text('Notas', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
     body: provider.loading
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
              return Dismissible(
                key: Key(n.id!),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  try {
                    await provider.deleteNote(n.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nota excluída')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao excluir nota: $e')),
                    );
                  }
                },
                child: ListTile(
                  title: Text(n.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(n.tags.join(', '), style: const TextStyle(color: Colors.white70)),
                  onTap: () => openEditor(n.id),
                ),
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
