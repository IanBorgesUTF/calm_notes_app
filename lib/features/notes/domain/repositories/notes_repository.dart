import 'package:calm_notes_app/features/notes/data/models/note_model.dart';
import 'package:calm_notes_app/features/notes/domain/entities/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesRepository {
  final supabase = Supabase.instance.client;

  Future<List<Note>> getNotes() async {
    final data = await supabase
        .from('notes')
        .select()
        .order('updated_at', ascending: false);

    return (data as List)
        .map((e) => NoteModel.fromJson(e).toModel())
        .toList();
  }

  Future<void> save(Note note) async {
    note.updatedAt = DateTime.now().millisecondsSinceEpoch;

    final dto = NoteModel.fromModel(note);

    await supabase.from('notes').upsert(dto.toJson());
  }

  Future<void> delete(String id) async {
    await supabase.from('notes').delete().eq('id', id);
  }
}
