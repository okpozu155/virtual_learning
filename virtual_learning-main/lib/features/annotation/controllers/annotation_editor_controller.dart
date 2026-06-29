import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/repositories/annotation_repository.dart';
import '../models/annotation_shape.dart';

class AnnotationEditorController extends ChangeNotifier {
  final AnnotationRepository _repository = AnnotationRepository();

  final List<AnnotationShape> shapes = [];

  AnnotationShape? selectedShape;

  bool placingShape = false;

  AnnotationShapeType? placingType;

  StreamSubscription<List<AnnotationShape>>? _shapesSubscription;

  bool _disposed = false;

  bool get hasSelection => selectedShape != null;

  void _notifyListeners() {
    if (_disposed) return;

    notifyListeners();
  }

  //====================================================
  // LOAD
  //====================================================

  Future<void> loadShapes(String slideId) async {
    final loaded = await _repository.loadShapes(slideId);

    shapes
      ..clear()
      ..addAll(loaded);

    selectedShape = null;

    _notifyListeners();
  }

  //====================================================
  // REALTIME
  //====================================================

  void startRealtimeSync(String slideId) {
    _shapesSubscription?.cancel();

    _shapesSubscription = _repository.streamShapes(slideId).listen((loaded) {
      final selectedId = selectedShape?.id;

      shapes
        ..clear()
        ..addAll(loaded);

      selectedShape = null;

      if (selectedId != null) {
        for (final shape in shapes) {
          if (shape.id == selectedId) {
            shape.selected = true;
            selectedShape = shape;
          } else {
            shape.selected = false;
          }
        }
      }

      _notifyListeners();
    });
  }

  //====================================================
  // PLACE MODE
  //====================================================

  void beginPlacement(AnnotationShapeType type) {
    placingShape = true;
    placingType = type;

    clearSelection(notify: false);

    _notifyListeners();
  }

  void cancelPlacement() {
    placingShape = false;
    placingType = null;

    _notifyListeners();
  }

  Future<AnnotationShape?> placeShape({
    required String slideId,
    required Offset position,
  }) async {
    if (!placingShape || placingType == null) {
      return null;
    }

    final shape = AnnotationShape(
      type: placingType!,
      center: position,
      width: 150,
      height: 110,
      selected: true,
    );

    shapes.add(shape);

    selectedShape = shape;

    placingShape = false;
    placingType = null;

    _notifyListeners();

    await _repository.createShape(slideId: slideId, shape: shape);

    return shape;
  }

  //====================================================
  // SELECTION
  //====================================================

  void selectShape(AnnotationShape shape) {
    for (final s in shapes) {
      s.selected = false;
    }

    shape.selected = true;

    selectedShape = shape;

    _notifyListeners();
  }

  void clearSelection({bool notify = true}) {
    for (final s in shapes) {
      s.selected = false;
    }

    selectedShape = null;

    if (notify) {
      _notifyListeners();
    }
  }

  //====================================================
  // MOVE
  //====================================================

  Future<void> moveSelected({
    required String slideId,
    required Offset delta,
  }) async {
    if (selectedShape == null) return;
    if (selectedShape!.fixed) return;

    selectedShape!.center += delta;

    _notifyListeners();

    await _repository.updateShape(slideId: slideId, shape: selectedShape!);
  }

  //====================================================
  // RESIZE
  //====================================================

  Future<void> resizeSelected({
    required String slideId,
    required double width,
    required double height,
  }) async {
    if (selectedShape == null) return;
    if (selectedShape!.fixed) return;

    if (width > 30) {
      selectedShape!.width = width;
    }

    if (height > 30) {
      selectedShape!.height = height;
    }

    _notifyListeners();

    await _repository.updateShape(slideId: slideId, shape: selectedShape!);
  }

  //====================================================
  // ROTATE
  //====================================================

  Future<void> rotateSelected({
    required String slideId,
    required double angle,
  }) async {
    if (selectedShape == null) return;

    selectedShape!.rotation += angle;

    _notifyListeners();

    await _repository.updateShape(slideId: slideId, shape: selectedShape!);
  }

  //====================================================
  // DETAILS
  //====================================================

  Future<void> updateShapeDetails({
    required String slideId,
    required String title,
    required String description,
    required String notes,
    required Color color,
  }) async {
    if (selectedShape == null) return;

    selectedShape!
      ..title = title
      ..description = description
      ..notes = notes
      ..color = color;

    _notifyListeners();

    await _repository.updateShape(slideId: slideId, shape: selectedShape!);
  }

  //====================================================
  // DUPLICATE
  //====================================================

  Future<void> duplicateSelected(String slideId) async {
    if (selectedShape == null) return;

    final duplicate = selectedShape!.clone();

    for (final s in shapes) {
      s.selected = false;
    }

    duplicate.selected = true;

    shapes.add(duplicate);

    selectedShape = duplicate;

    _notifyListeners();

    await _repository.createShape(slideId: slideId, shape: duplicate);
  }

  //====================================================
  // DELETE
  //====================================================

  Future<void> deleteSelected(String slideId) async {
    if (selectedShape == null) return;

    final id = selectedShape!.id;

    shapes.removeWhere((shape) => shape.id == id);

    selectedShape = null;

    _notifyListeners();

    await _repository.deleteShape(slideId: slideId, annotationId: id);
  }

  //====================================================
  // CLEAR
  //====================================================

  void clear() {
    shapes.clear();

    selectedShape = null;

    placingShape = false;

    placingType = null;

    _notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _shapesSubscription?.cancel();
    super.dispose();
  }
}
