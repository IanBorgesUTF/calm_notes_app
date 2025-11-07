import 'package:calm_notes_app/dto/note/note_dto.dart';
import 'package:calm_notes_app/models/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesRepository {
  final supabase = Supabase.instance.client;

  Future<List<Note>> getNotes() async {
    final data = await supabase
        .from('notes')
        .select()
        .order('updated_at', ascending: false);

    return (data as List)
        .map((e) => NoteDto.fromJson(e).toModel())
        .toList();
  }

  Future<void> save(Note note) async {
    note.updatedAt = DateTime.now().millisecondsSinceEpoch;

    final dto = NoteDto.fromModel(note);

    await supabase.from('notes').upsert(dto.toJson());
  }

  Future<void> delete(String id) async {
    await supabase.from('notes').delete().eq('id', id);
  }
}
