import 'dart:ui';

class PolygonModel {
  final String id;
  final String slideId;
  final String title;
  final String description;
  final String notes;
  final String color;
  final List<Offset> points;

  PolygonModel({
    required this.id,
    required this.slideId,
    required this.title,
    required this.description,
    required this.notes,
    required this.color,
    required this.points,
  });

  factory PolygonModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return PolygonModel(
      id: id,
      slideId: data['slideId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      notes: data['notes'] ?? '',
      color: data['color'] ?? '#00FF00',
      points: (data['points'] as List<dynamic>? ?? [])
          .map(
            (point) => Offset(
          (point['x'] as num).toDouble(),
          (point['y'] as num).toDouble(),
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slideId': slideId,
      'title': title,
      'description': description,
      'notes': notes,
      'color': color,
      'type': 'polygon',
      'points': points
          .map(
            (point) => {
          'x': point.dx,
          'y': point.dy,
        },
      )
          .toList(),
    };
  }
}