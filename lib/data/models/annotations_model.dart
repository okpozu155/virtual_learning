import 'package:flutter/material.dart';

class AnnotationPoint {
  final double x;
  final double y;

  AnnotationPoint({required this.x, required this.y});

  factory AnnotationPoint.fromJson(Map<String, dynamic> json) {
    return AnnotationPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}

class AnnotationModel {
  final String id;
  final String type; // 'polygon' or 'polyline'
  final String label;
  final String description;
  final String colorHex; // Stored as String to keep JSON clean
  final List<AnnotationPoint> points;

  AnnotationModel({
    required this.id,
    required this.type,
    required this.label,
    required this.description,
    required this.colorHex,
    required this.points,
  });

  factory AnnotationModel.fromJson(Map<String, dynamic> json) {
    var pointsList = json['points'] as List;
    List<AnnotationPoint> parsedPoints = pointsList
        .map((p) => AnnotationPoint.fromJson(p))
        .toList();

    return AnnotationModel(
      id: json['id'],
      type: json['type'],
      label: json['label'],
      description: json['description'],
      colorHex: json['color'],
      points: parsedPoints,
    );
  }

  // Helper method to convert the hex string into a functional Flutter Color object
  Color get color {
    final hexCode = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
