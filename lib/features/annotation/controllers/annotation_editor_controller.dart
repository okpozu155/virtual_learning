import 'package:flutter/material.dart';

import '../../../data/repositories/annotation_repository.dart';
import '../models/annotation_shape.dart';

class AnnotationEditorController extends ChangeNotifier {
  final AnnotationRepository _repository = AnnotationRepository();

  final List<AnnotationShape> shapes = [];

  AnnotationShape? selectedShape;

  bool placingShape = false;

  AnnotationShapeType? placingType;

  bool get hasSelection => selectedShape != null;

  //====================================================
  // LOAD
  //====================================================

  Future<void> loadShapes(String slideId) async {
    final loaded = await _repository.loadShapes(slideId);

    shapes
      ..clear()
      ..addAll(loaded);

    selectedShape = null;

    notifyListeners();
  }

  //====================================================
  // REALTIME
  //====================================================

  void startRealtimeSync(String slideId) {
    _repository.streamShapes(slideId).listen((loaded) {
      shapes
        ..clear()
        ..addAll(loaded);

      selectedShape = null;

      notifyListeners();
    });
  }

  //====================================================
  // PLACE MODE
  //====================================================

  void beginPlacement(AnnotationShapeType type) {
    placingShape = true;
    placingType = type;

    clearSelection(notify: false);

    notifyListeners();
  }

  void cancelPlacement() {
    placingShape = false;
    placingType = null;

    notifyListeners();
  }

  Future<void> placeShape({
    required String slideId,
    required Offset position,
  }) async {
    if (!placingShape || placingType == null) {
      return;
    }

    print("PLACE SHAPE");
    print("Slide = $slideId");
    print("Position = $position");


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

    notifyListeners();

    await _repository.createShape(
      slideId: slideId,
      shape: shape,
    );
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

    notifyListeners();
  }

  void clearSelection({
    bool notify = true,
  }) {
    for (final s in shapes) {
      s.selected = false;
    }

    selectedShape = null;

    if (notify) {
      notifyListeners();
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

    selectedShape!.center += delta;

    notifyListeners();

    await _repository.updateShape(
      slideId: slideId,
      shape: selectedShape!,
    );
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

    if (width > 30) {
      selectedShape!.width = width;
    }

    if (height > 30) {
      selectedShape!.height = height;
    }

    notifyListeners();

    await _repository.updateShape(
      slideId: slideId,
      shape: selectedShape!,
    );
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

    notifyListeners();

    await _repository.updateShape(
      slideId: slideId,
      shape: selectedShape!,
    );
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

    notifyListeners();

    await _repository.updateShape(
      slideId: slideId,
      shape: selectedShape!,
    );
  }

  //====================================================
  // DUPLICATE
  //====================================================

  Future<void> duplicateSelected(
      String slideId,
      ) async {
    if (selectedShape == null) return;

    final duplicate = selectedShape!.clone();

    for (final s in shapes) {
      s.selected = false;
    }

    duplicate.selected = true;

    shapes.add(duplicate);

    selectedShape = duplicate;

    notifyListeners();

    await _repository.createShape(
      slideId: slideId,
      shape: duplicate,
    );
  }

  //====================================================
  // DELETE
  //====================================================

  Future<void> deleteSelected(
      String slideId,
      ) async {
    if (selectedShape == null) return;

    final id = selectedShape!.id;

    shapes.remove(selectedShape);

    selectedShape = null;

    notifyListeners();

    await _repository.deleteShape(
      slideId: slideId,
      annotationId: id,
    );
  }

  //====================================================
  // CLEAR
  //====================================================

  void clear() {
    shapes.clear();

    selectedShape = null;

    placingShape = false;

    placingType = null;

    notifyListeners();
  }
}