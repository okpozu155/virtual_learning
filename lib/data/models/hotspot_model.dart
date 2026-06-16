class HotspotModel {
  final String id;
  final String title;
  final String description;
  final double x;
  final double y;

  HotspotModel({
    required this.id,
    required this.title,
    required this.description,
    required this.x,
    required this.y,
  });

  factory HotspotModel.fromJson(
      Map<String, dynamic> json) {
    return HotspotModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
    );
  }
}