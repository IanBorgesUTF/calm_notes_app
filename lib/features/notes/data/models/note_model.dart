import '../../domain/entities/note.dart';

class NoteModel {
  String? id;
  String userId;
  String title;
  String content;
  List<String> tags;
  int updatedAt;
  int? deletedAt;

  NoteModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.updatedAt,
    this.deletedAt,
  });

  factory NoteModel.fromModel(Note note) {
    return NoteModel(
      id: note.id,
      userId: note.userId,
      title: note.title,
      content: note.content,
      tags: note.tags,
      updatedAt: note.updatedAt,
      deletedAt: note.deletedAt,
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
      deletedAt: deletedAt,
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
      deletedAt: json['deleted_at'] as int?,
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
      if (deletedAt != null) 'deleted_at': deletedAt,
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
      deletedAt: note.deletedAt,
    );
  }
}
