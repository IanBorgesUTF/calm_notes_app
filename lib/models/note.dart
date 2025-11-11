class Note {
  String? id;
  String userId;
  String title;
  String content;
  List<String> tags;
  int updatedAt;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toString(),
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      updatedAt: map['updated_at'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'tags': tags,
      'updated_at': updatedAt,
    };
  }

  Note copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? tags,
    int? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
