import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/note.dart';

class NotesProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;
  

  List<Note> notes = [];
  bool loading = false;

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<void> loadNotes() async {
    final uid = currentUserId;
    if (uid == null) return;

    loading = true;
    notifyListeners();

    final res = await _client
        .from('notes')
        .select()
        .eq('user_id', uid)
        .isFilter('deleted_at', null)
        .order('updated_at', ascending: false);

    notes = (res as List).map((e) => Note.fromMap(e)).toList();

    loading = false;
    notifyListeners();
  }

  Future<void> upsertNote(Note note) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Usuário não autenticado');

    final updatedNote = note.copyWith(
      userId: uid,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    final res = await _client
        .from('notes')
        .upsert(updatedNote.toMap())
        .select()
        .single();

    updatedNote.id = res['id'].toString();

    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    await _client.from('notes').update({'deleted_at': ts}).eq('id', id);
    await loadNotes();
  }
}
