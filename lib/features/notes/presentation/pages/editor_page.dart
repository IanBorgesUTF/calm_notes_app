import 'package:calm_notes_app/features/notes/domain/entities/note.dart';
import 'package:calm_notes_app/features/notes/presentation/providers/notes_provider.dart';
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

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
        actions: [
          IconButton(
            icon: saving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onPrimary,
                    ),
                  )
                : Icon(Icons.save, color: colors.onPrimary),
            onPressed: saving ? null : save,
          )
        ],
        backgroundColor: colors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              style: TextStyle(color: colors.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Título',
                hintStyle: TextStyle(color: colors.onSurfaceVariant),
              ),
            ),
            Divider(color: colors.onSurface.withAlpha(12)),
            Expanded(
              child: TextField(
                controller: contentCtrl,
                style: TextStyle(color: colors.onSurface),
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escreva seus lembretes...',
                  hintStyle: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
