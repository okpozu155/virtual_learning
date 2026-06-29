class NoteModel {
  final String id;
  final String title;
  final String body;
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
  });

  NoteModel copyWith({String? title, String? body, DateTime? updatedAt}) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
