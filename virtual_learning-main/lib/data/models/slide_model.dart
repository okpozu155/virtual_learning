class SlideModel {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String description;

  SlideModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.description,
  });

  factory SlideModel.fromJson(
      Map<String, dynamic> json) {
    return SlideModel(
      id: json['id'],
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      description:
      json['description'] ?? '',
    );
  }
}