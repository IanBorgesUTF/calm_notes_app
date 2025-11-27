import '../../domain/entities/note.dart';

class NoteModel {
  String? id;
  String userId;
  String title;
  String content;
  List<String> tags;
  int updatedAt;

  NoteModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.updatedAt,
  });

  factory NoteModel.fromModel(Note note) {
    return NoteModel(
      id: note.id,
      userId: note.userId,
      title: note.title,
      content: note.content,
      tags: note.tags,
      updatedAt: note.updatedAt,
    );
  }

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

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      updatedAt: json['updated_at'] ?? 0,
    );
  }

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

  factory NoteModel.fromModelWithUser(Note note, String userId) {
    return NoteModel(
      id: note.id,
      userId: userId,
      title: note.title,
      content: note.content,
      tags: note.tags,
      updatedAt: note.updatedAt,
    );
  }
}
