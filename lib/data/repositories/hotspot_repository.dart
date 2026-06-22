import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../models/hotspot_model.dart';

class HotspotRepository {
     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

     Future<List<HotspotModel>> getHotspots(String slideId) async {
      try {
        DocumentSnapshot doc = await _firestore.collection('hotspots').doc(slideId).get();

        if (!doc.exists || doc.data() == null) {
          return [];
        }

        final data = doc.data() as Map<String, dynamic>;

        if (data['hotspots'] == null) {
          return [];
        }
           
        return (data['hotspots'] as List)
            .map((e) => HotspotModel.fromJson(e))
            .toList();
      } catch (e) {
        print('Error fetching hotspots from Firestore: $e');
        return [];
      }
     }
} 
/*   Future<List<HotspotModel>> getHotspots(
      String slideId) async {

    final jsonString =
    await rootBundle.loadString(
      'assets/data/hotspots.json',
    );

    final List<dynamic> data =
    json.decode(jsonString);

    final slideData = data.firstWhere(
          (e) => e['slideId'] == slideId,
      orElse: () => null,
    );

    if (slideData == null) {
      return [];
    }

    return (slideData['hotspots'] as List)
        .map(
          (e) => HotspotModel.fromJson(e),
    )
        .toList();
  }
*/