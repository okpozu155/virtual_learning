import 'package:flutter/material.dart';

import '../../../data/models/hotspot_model.dart';


class MicroscopeController {
  final TransformationController transformationController =
  TransformationController();

  String slideImage =
      'assets/images/slides/blood_smear.jpg';

  List<HotspotModel> hotspots = [];

  void zoomIn() {
    transformationController.value =
        transformationController.value.scaled(1.2);
  }

  void zoomOut() {
    transformationController.value =
        transformationController.value.scaled(0.8);
  }

  void resetZoom() {
    transformationController.value = Matrix4.identity();
  }

  void dispose() {
    transformationController.dispose();
  }
}