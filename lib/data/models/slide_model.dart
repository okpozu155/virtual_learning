class SlideModel {
  final String id;
  final String title;
  final String imagePath;
  final String category;
  final String description;
  final bool downloaded;

  SlideModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.description,
    this.downloaded = false,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id'],
      title: json['title'],
      imagePath: json['imagePath'],
      category: json['category'],
      description: json['description'],
      downloaded: json['downloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'category': category,
      'description': description,
      'downloaded': downloaded,
    };
  }
}