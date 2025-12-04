import 'package:calm_notes_app/core/sync_service.dart';
import 'package:calm_notes_app/features/notes/data/datasources/local_notes_datasource.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/note.dart';

class NotesProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;

  final LocalNotesDataSource localNotesDataSource;
  final SyncService syncService;

  NotesProvider({required this.localNotesDataSource, required this.syncService});

  

  List<Note> notes = [];
  bool loading = false;

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<void> loadNotes({bool forceSync = false}) async {
    final uid = currentUserId;
    if (uid == null) return;

    loading = true;
    notifyListeners();

    final local = await localNotesDataSource.getAllNotes();

     notes = local
        .where((m) => (m['user_id']?.toString() ?? '') == uid && (m['deleted_at'] == null))
        .map((m) => Note.fromMap(m))
        .toList();

    if (syncService.isOnline || forceSync){
      try {
        final res = await _client
            .from('notes')
            .select()
            .eq('user_id', uid)
            .isFilter('deleted_at', null)
            .order('updated_at', ascending: false);

        final remoteNotes = (res as List).map((e) => Note.fromMap(e)).toList();
        notes = remoteNotes;

        for (final m in res) {
          final map = Map<String, dynamic>.from(m);
          await localNotesDataSource.markSynced(map['id'].toString(), map);
        }
      } catch (_) {
      }
    }

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

    final map = updatedNote.toMap();
    await localNotesDataSource.saveNote(map, pendingAction: 'upsert');

    await loadNotes();

    if (syncService.isOnline) {
      await syncService.syncNow();
      await loadNotes();
    }
  }

  Future<void> deleteNote(String id) async {
    await localNotesDataSource.deleteNote(id);

    await loadNotes();

    if (syncService.isOnline) {
      await syncService.syncNow();
      await loadNotes();
    }
  }

  Future<void> syncNow() async {
    if (syncService.isOnline) {
      await syncService.syncNow();
      await loadNotes();
    }
  }

}
