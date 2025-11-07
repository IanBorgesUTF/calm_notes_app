// lib/dto/note/note_dto.dart
import '../../models/note.dart';

class NoteDto {
  String? id;
  String userId;
  String title;
  String content;
  List<String> tags;
  int updatedAt;

  NoteDto({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.updatedAt,
  });

  // Converter de Note Model -> NoteDto
  factory NoteDto.fromModel(Note note) {
    return NoteDto(
      id: note.id,
      userId: note.userId,
      title: note.title,
      content: note.content,
      tags: note.tags,
      updatedAt: note.updatedAt,
    );
  }

  // Converter de NoteDto -> Note Model
  Note toModel() {
    return Note(
      id: id,
      userId: userId,
      title: title,
      content: content,
      tags: tags,
      updatedAt: updatedAt,
    );
  }

  // Criar NoteDto a partir de JSON do Supabase
  factory NoteDto.fromJson(Map<String, dynamic> json) {
    return NoteDto(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '', // obrigatório
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      updatedAt: json['updated_at'] ?? 0,
    );
  }

  // Converter NoteDto -> JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'tags': tags,
      'updated_at': updatedAt,
    };
  }

  factory NoteDto.fromModelWithUser(Note note, String userId) {
    return NoteDto(
      id: note.id,
      userId: userId,
      title: note.title,
      content: note.content,
      tags: note.tags,
      updatedAt: note.updatedAt,
    );
  }
}
