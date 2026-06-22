import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_learning/data/models/hotspot_model.dart';
import 'package:virtual_learning/data/models/annotations_model.dart';

void main() {
  group('Hotspot and Annotation Data Layer Verification Tests', () {
    
    test('Verify HotspotModel successfully decodes valid JSON structure', () {
      final mockHotspotJson = {
        "id": "hs_999",
        "title": "Test Nucleus Pin",
        "x": 45.5,
        "y": 62.0,
        "description": "Validation testing specimen point."
      };

      final hotspot = HotspotModel.fromJson(mockHotspotJson);

      expect(hotspot.id, 'hs_999');
      expect(hotspot.title, 'Test Nucleus Pin');
      expect(hotspot.x, 45.5);
      expect(hotspot.y, 62.0);
    });

    test('Verify AnnotationModel successfully decodes a polygon collection', () {
      final mockAnnotationJson = {
        "id": "anno_999",
        "type": "polygon",
        "label": "Test Zone",
        "color": "#33A8FF",
        "description": "Validation testing vector shape.",
        "points": [
          {"x": 10.0, "y": 20.0},
          {"x": 30.0, "y": 40.0}
        ]
      };

      final annotation = AnnotationModel.fromJson(mockAnnotationJson);

      expect(annotation.id, 'anno_999');
      expect(annotation.type, 'polygon');
      expect(annotation.points.length, 2);
      expect(annotation.points[0].x, 10.0);
      expect(annotation.points[1].y, 40.0);
    });
    
    test('Verify Hex Color Conversion helper resolves clean Flutter Color objects', () {
      final mockAnnotationJson = {
        "id": "anno_color_test",
        "type": "polyline",
        "label": "Color Boundary",
        "color": "#FF5733",
        "description": "Testing red hex translation.",
        "points": [{"x": 1.0, "y": 1.0}]
      };

      final annotation = AnnotationModel.fromJson(mockAnnotationJson);
      
      // Verifies that the hex string converts into the matching ARGB structural signature
      expect(annotation.color.value, equals(0xFFFF5733));
    });
  });
}
