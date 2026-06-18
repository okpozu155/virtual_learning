class SlideModel {
  final String id;
  final String title;
  final String imagePath;
  final String category;
  final String description;
  final String text;
  final bool downloaded;
  final int completion;

  SlideModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.description,
    required this.text,
    this.downloaded = false,
    this.completion = 0,
  });

  factory SlideModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SlideModel(
      id: json['id'],
      title: json['title'],
      imagePath: json['imagePath'],
      category: json['category'],
      description: json['description'],
      text: json['text'] ?? '',
      downloaded: json['downloaded'] ?? false,
      completion: json['completion'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'category': category,
      'description': description,
      'text': text,
      'downloaded': downloaded,
      'completion': completion,
    };
  }
}