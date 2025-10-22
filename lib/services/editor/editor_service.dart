import 'package:calm_notes_app/models/note.dart';
import 'package:calm_notes_app/services/storage/storage_service.dart';
import 'package:flutter/material.dart';

class EditorService {
  bool privacyLocal = true;
  final StorageService storageService = StorageService();

Future<void> init(final String? noteId, Note note, final TextEditingController titleCtrl, final TextEditingController contentCtrl) async {
  privacyLocal = await storageService.getPrivacyFlag();
  final notes = await storageService.loadNotes();

  if (noteId != null) {
    note = notes.firstWhere(
      (n) => n.id == noteId,
      orElse: () => Note(
        id: noteId,
        title: '',
        content: '',
        tags: [],
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  } else {
    note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      content: '',
      tags: [],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  titleCtrl.text = note.title;
  contentCtrl.text = note.content;
}

Future<void> save(BuildContext context, Note note, final TextEditingController titleCtrl, final TextEditingController contentCtrl) async {
  if (titleCtrl.text.trim().isEmpty && contentCtrl.text.trim().isEmpty) {
    Navigator.of(context).pop(); 
    return;
  }

  final n = Note(
    id: note.id,
    title: titleCtrl.text.isEmpty ? 'Sem título' : titleCtrl.text,
    content: contentCtrl.text,
    tags: note.tags,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );

  await storageService.saveNote(n);
  Navigator.of(context).pop();
}
}
