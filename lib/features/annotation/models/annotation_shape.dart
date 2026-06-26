import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum AnnotationShapeType {
  rectangle,
  octagon,
}

class AnnotationShape {
  final String id;

  AnnotationShapeType type;

  Offset center;

  double width;

  double height;

  double rotation;

  Color color;

  bool selected;

  String title;

  String description;

  String notes;

  AnnotationShape({
    String? id,
    required this.type,
    required this.center,
    required this.width,
    required this.height,
    this.rotation = 0,
    this.color = Colors.red,
    this.selected = false,
    this.title = '',
    this.description = '',
    this.notes = '',
  }) : id = id ?? const Uuid().v4();

  /// Rectangle occupied by this shape
  Rect get rect => Rect.fromCenter(
    center: center,
    width: width,
    height: height,
  );

  /// Duplicate shape with a small offset
  AnnotationShape clone() {
    return AnnotationShape(
      type: type,
      center: center + const Offset(20, 20),
      width: width,
      height: height,
      rotation: rotation,
      color: color,
      title: title,
      description: description,
      notes: notes,
    );
  }

  /// Shape vertices
  List<Offset> polygonPoints() {
    switch (type) {
      case AnnotationShapeType.rectangle:
        return _rectanglePoints();

      case AnnotationShapeType.octagon:
        return _octagonPoints();
    }
  }

  List<Offset> _rectanglePoints() {
    final r = rect;

    return [
      Offset(r.left, r.top),
      Offset(r.right, r.top),
      Offset(r.right, r.bottom),
      Offset(r.left, r.bottom),
    ];
  }

  List<Offset> _octagonPoints() {
    final r = rect;

    final cutX = width * .25;
    final cutY = height * .25;

    return [
      Offset(r.left + cutX, r.top),
      Offset(r.right - cutX, r.top),
      Offset(r.right, r.top + cutY),
      Offset(r.right, r.bottom - cutY),
      Offset(r.right - cutX, r.bottom),
      Offset(r.left + cutX, r.bottom),
      Offset(r.left, r.bottom - cutY),
      Offset(r.left, r.top + cutY),
    ];
  }

  /// Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      "type": "polygon",
      "shape": type.name,
      "title": title,
      "description": description,
      "notes": notes,
      "rotation": rotation,
      "color": color.value,
      "points": polygonPoints()
          .map(
            (p) => {
          "x": p.dx,
          "y": p.dy,
        },
      )
          .toList(),
    };
  }

  /// Firestore deserialization
  factory AnnotationShape.fromFirestore(
      String id,
      Map<String, dynamic> json,
      ) {
    final pointList = (json["points"] as List<dynamic>? ?? []);

    if (pointList.isEmpty) {
      return AnnotationShape(
        id: id,
        type: AnnotationShapeType.rectangle,
        center: const Offset(150, 150),
        width: 150,
        height: 100,
      );
    }

    final points = pointList
        .map(
          (e) => Offset(
        (e["x"] as num).toDouble(),
        (e["y"] as num).toDouble(),
      ),
    )
        .toList();

    double minX = points.first.dx;
    double maxX = points.first.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;

    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }

    return AnnotationShape(
      id: id,
      type: json["shape"] == "octagon"
          ? AnnotationShapeType.octagon
          : AnnotationShapeType.rectangle,
      center: Offset(
        (minX + maxX) / 2,
        (minY + maxY) / 2,
      ),
      width: maxX - minX,
      height: maxY - minY,
      rotation: (json["rotation"] ?? 0).toDouble(),
      color: Color(json["color"] ?? Colors.red.value),
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      notes: json["notes"] ?? '',
    );
  }
}