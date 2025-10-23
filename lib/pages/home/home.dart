import 'dart:io';
import 'package:calm_notes_app/models/note.dart';
import 'package:calm_notes_app/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/theme.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Note> notes = [];
  bool loading = true;
  String? profileImagePath;

  final StorageService storageService = StorageService();

  @override
  void initState() {
    super.initState();
    load();
    loadProfileImage();
  }

  Future<void> load() async {
    final loadNotes = await storageService.loadNotes();
    setState(() {
      notes = loadNotes;
      loading = false;
    });
  }

  Future<void> loadProfileImage() async {
    final path = await storageService.loadProfileImagePath();
    setState(() {
      profileImagePath = path;
    });
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final dir = await getApplicationDocumentsDirectory();
      final localImage = File('${dir.path}/profile.jpg');
      await File(image.path).copy(localImage.path);

      await storageService.saveProfileImagePath(localImage.path);
      setState(() {
        profileImagePath = localImage.path;
      });
    }
  }

  void openEditor([String? id]) {
    Navigator.of(context)
        .pushNamed(Routes.editorPage, arguments: {'id': id}).then((_) => load());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CalmNotes'),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: pickProfileImage,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[700],
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath!))
                      : null,
                  child: profileImagePath == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : notes.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma nota encontrada. Toque no ícone + para criar uma nova nota.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (_, i) {
                      final n = notes[i];
                      return Dismissible(
                        key: Key(n.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 28),
                        ),
                        onDismissed: (_) async {
                          await storageService.deleteNote(n.id);
                          setState(() => notes.removeAt(i));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nota "${n.title}" excluída'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(n.title,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            n.tags.join(', '),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () => openEditor(n.id),
                        ),
                      );
                    },
                  ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mint,
          child: const Icon(Icons.note_add),
          onPressed: () => openEditor(),
        ),
      ),
    );
  }
}
