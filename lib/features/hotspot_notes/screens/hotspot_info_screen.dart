import 'package:flutter/material.dart';

import '../../../data/models/hotspot_model.dart';

class HotspotInfoScreen extends StatelessWidget {
  const HotspotInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hotspot =
    ModalRoute.of(context)!.settings.arguments
    as HotspotModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(hotspot.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  hotspot.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  hotspot.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}