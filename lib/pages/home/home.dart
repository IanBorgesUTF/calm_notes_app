import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/theme.dart';
import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../services/storage/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onNext});

   final VoidCallback? onNext;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Note> notes = [];
  bool loading = true;

  final StorageService storageService = StorageService();


  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final loadNotes = await storageService.loadNotes();
    setState(() {
      notes = loadNotes;
      loading = false;
    });
  }

  void openEditor([String? id]) {
    Navigator.of(context).pushNamed(Routes.editorPage, arguments: {'id': id}).then((_) => load());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CalmNotes'),
          automaticallyImplyLeading: false,
        ),
        body: notes.isEmpty 
        ? Center(
          child: Text('Nenhuma nota encontrada. Toque no ícone + para criar uma nova nota.', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 16
            ), 
            textAlign: TextAlign.center, 
            ),
          ) 
        :  loading
    ? const Center(child: CircularProgressIndicator())
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
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
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
              title: Text(n.title, style: const TextStyle(color: Colors.white)),
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
