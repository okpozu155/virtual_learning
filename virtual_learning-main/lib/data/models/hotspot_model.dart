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

  factory HotspotModel.fromJson(Map<String, dynamic> json) {
    return HotspotModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      description: json['description']?.toString() ?? '',
    );
  }
}
