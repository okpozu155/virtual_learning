import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/hotspot_card.dart';

class HotspotListScreen
    extends StatelessWidget {
  final String slideId;

  const HotspotListScreen({
    super.key,
    required this.slideId,
  });


  @override
  Widget build(BuildContext context) {
    debugPrint(
        "HotspotListScreen opened"
    );

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Hotspots"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('slides')
            .doc(slideId)
            .collection('hotspots')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          return ListView(
            children:
            snapshot.data!.docs.map((doc) {
              return HotspotCard(
                title: doc['title'],
                description:
                doc['description'],
                onDelete: () async {
                  await doc.reference
                      .delete();
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}