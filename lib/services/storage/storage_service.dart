import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/note.dart';

const key = 'calm_notes_v1';
const privKey = 'calm_notes_privacy_v1';

String _uid() => '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch % 1000}';

class StorageService {


   Future<List<Note>> loadNotes() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(key);
    if (raw == null) {
      final initial = [
        Note(
          id: _uid(),
          title: 'Resumo Aula 1',
          content: 'Escreva aqui o resumo da aula 1...',
          tags: ['aula', 'resumo'],
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        )
      ];
      sp.setString(key, jsonEncode(initial.map((n) => n.toJson()).toList()));
      return initial;
    }
    try {
      final list = (jsonDecode(raw) as List).map((e) => Note.fromJson(e)).toList();
      return list;
    } catch (_) {
      return [];
    }
  }

 Future<void> saveNote(Note note) async {
  final sp = await SharedPreferences.getInstance();
  final notes = await loadNotes();

  note.updatedAt = DateTime.now().millisecondsSinceEpoch;

  final index = notes.indexWhere((n) => n.id == note.id);
  if (index >= 0) {
    notes[index] = note; 
  } else {
    notes.insert(0, note); 
  }

  await sp.setString(key, jsonEncode(notes.map((n) => n.toJson()).toList()));
}



   Future<void> deleteNote(String id) async {
    final sp = await SharedPreferences.getInstance();
    final notes = await loadNotes();
    notes.removeWhere((n) => n.id == id);
    sp.setString(key, jsonEncode(notes.map((n) => n.toJson()).toList()));
  }

   Future<bool> getPrivacyFlag() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(privKey) ?? true;
  }

   Future<void> setPrivacyFlag(bool v) async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool(privKey, v);
  }
}
