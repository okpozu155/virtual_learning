class HotspotModel {
  final String id;
  final String title;
  final double x;
  final double y;
  final String description;

  HotspotModel({
    required this.id,
    required this.title,
    required this.x,
    required this.y,
    required this.description,
  });

  factory HotspotModel.fromJson(
      Map<String, dynamic> json) {
    return HotspotModel(
      id: json['id'],
      title: json['title'],
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      description: json['description'],
    );
  }
}