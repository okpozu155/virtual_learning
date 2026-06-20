import 'package:flutter/material.dart';

import '../../../core/services/local_storage_service.dart';
import '../../../data/repositories/slide_repository.dart';

class RecentTopicsScreen extends StatefulWidget {
  const RecentTopicsScreen({super.key});

  @override
  State<RecentTopicsScreen> createState() =>
      _RecentTopicsScreenState();
}

class _RecentTopicsScreenState
    extends State<RecentTopicsScreen> {
  final repository = SlideRepository();

  List<String> recentIds = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    recentIds =
    await LocalStorageService()
        .getRecentSlides();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Recent Topics")),
      body: ListView.builder(
        itemCount: recentIds.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future:
            repository.getSlideById(
              recentIds[index],
            ),
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
              );
            },
          );
        },
      ),
    );
  }
}