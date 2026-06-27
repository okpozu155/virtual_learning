import 'package:flutter/material.dart';

import '../../../core/services/local_storage_service.dart';
import '../../../data/models/slide_model.dart';
import '../../../data/repositories/slide_repository.dart';
import '../../microscope/screens/microscope_screen.dart';

class RecentTopicsScreen extends StatefulWidget {
  const RecentTopicsScreen({super.key});

  @override
  State<RecentTopicsScreen> createState() => _RecentTopicsScreenState();
}

class _RecentTopicsScreenState extends State<RecentTopicsScreen> {
  final repository = SlideRepository();
  final storage = LocalStorageService();

  List<String> recentIds = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    recentIds = await storage.getRecentSlides();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> openSlide(SlideModel slide) async {
    await storage.saveLastViewedSlide(slide.id);

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MicroscopeScreen(slide: slide)),
    );

    await load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Topics")),
      body: ListView.builder(
        itemCount: recentIds.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: repository.getSlideById(recentIds[index]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final slide = snapshot.data!;

              return ListTile(
                leading: Image.network(
                  slide.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(slide.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openSlide(slide),
              );
            },
          );
        },
      ),
    );
  }
}
