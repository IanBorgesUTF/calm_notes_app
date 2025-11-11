import 'package:calm_notes_app/models/note.dart';
import 'package:calm_notes_app/providers/notes/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorPage extends StatefulWidget {
  final String? noteId;
  const EditorPage({super.key, this.noteId});

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  Note? note;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NotesProvider>();
      if (widget.noteId == null) {
        note = Note(
          id: null,
          userId: provider.currentUserId ?? '',
          title: '',
          content: '',
          tags: [],
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );
      } else {
        note = provider.notes.firstWhere(
          (n) => n.id == widget.noteId,
          orElse: () => Note(
            id: widget.noteId,
            userId: provider.currentUserId ?? '',
            title: '',
            content: '',
            tags: [],
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
      titleCtrl.text = note!.title;
      contentCtrl.text = note!.content;
      setState(() {});
    });
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (titleCtrl.text.trim().isEmpty && contentCtrl.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    setState(() => saving = true);
    final provider = context.read<NotesProvider>();

    final updated = note!.copyWith(
      title: titleCtrl.text.trim().isEmpty ? 'Sem título' : titleCtrl.text,
      content: contentCtrl.text,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    try {
      await provider.upsertNote(updated);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar nota: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (note == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
        actions: [
          IconButton(
            icon: saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save),
            onPressed: saving ? null : save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Título',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const Divider(color: Color.fromRGBO(255,255,255,0.12)),
            Expanded(
              child: TextField(
                controller: contentCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escreva seus lembretes...',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
