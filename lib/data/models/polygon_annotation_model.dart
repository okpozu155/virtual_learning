class PolygonPoint {
  final double x;
  final double y;

  PolygonPoint({
    required this.x,
    required this.y,
  });

  factory PolygonPoint.fromMap(
      Map<String, dynamic> map,
      ) {
    return PolygonPoint(
      x: (map['x'] as num).toDouble(),
      y: (map['y'] as num).toDouble(),
    );
  }
}

class PolygonAnnotation {
  final String id;
  final String title;
  final String color;
  final List<PolygonPoint> points;

  PolygonAnnotation({
    required this.id,
    required this.title,
    required this.color,
    required this.points,
  });
}