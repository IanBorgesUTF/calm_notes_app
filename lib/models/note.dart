class Note {
  String id;
  String title;
  String content;
  List<String> tags;
  int updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        updatedAt: json['updatedAt'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'tags': tags,
        'updatedAt': updatedAt,
      };
}
