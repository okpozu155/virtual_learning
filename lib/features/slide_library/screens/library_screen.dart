import 'package:flutter/material.dart';

import '../../../core/services/local_storage_service.dart';
import '../../../data/models/slide_model.dart';
import '../../../data/repositories/slide_repository.dart';
import '../../microscope/screens/microscope_screen.dart';
import '../../../core/services/progress_service.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() =>
      _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final SlideRepository repository =
  SlideRepository();
  Map<String, int> slideProgress = {};

  final TextEditingController searchController =
  TextEditingController();

  List<SlideModel> allSlides = [];
  List<SlideModel> filteredSlides = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSlides();
  }

  Future<void> loadSlides() async {
    try {
      final slides =
      await repository.getSlides();

      Map<String, int> progressMap = {};

      for (final slide in slides) {
        progressMap[slide.id] =
        await ProgressService.getProgress(
          slide.id,
        );
      }

      setState(() {
        allSlides = slides;
        filteredSlides = slides;
        slideProgress = progressMap;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  void filterSlides(String query) {
    setState(() {
      filteredSlides = allSlides
          .where(
            (slide) =>
        slide.title
            .toLowerCase()
            .contains(
          query.toLowerCase(),
        ) ||
            slide.category
                .toLowerCase()
                .contains(
              query.toLowerCase(),
            ),
      )
          .toList();
    });
  }

  String getStatus(int progress) {
    if (progress == 0) {
      return "Not Started";
    }

    if (progress < 100) {
      return "In Progress";
    }

    return "Completed";
  }

  Color getStatusColor(int progress) {
    if (progress == 0) {
      return Colors.grey;
    }

    if (progress < 100) {
      return Colors.orange;
    }

    return Colors.green;
  }

  Future<void> openSlide(
      SlideModel slide,
      ) async {
    await LocalStorageService()
        .saveLastViewedSlide(slide.id);

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MicroscopeScreen(
          slide: slide,
        ),
      ),
    );

    await loadSlides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slide Library"),
      ),
      body: loading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.all(
              16,
            ),
            child: TextField(
              controller:
              searchController,
              onChanged:
              filterSlides,
              decoration:
              InputDecoration(
                hintText:
                "Search slides...",
                prefixIcon:
                const Icon(
                  Icons.search,
                ),
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    12,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount:
              filteredSlides
                  .length,
              itemBuilder:
                  (context,
                  index) {
                final slide =
                filteredSlides[
                index];


                final progress =
                    slideProgress[slide.id] ?? 0;

                debugPrint(
                  "Library progress for ${slide.id}: $progress",
                );

                return Card(
                  margin:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: InkWell(
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                    onTap: () =>
                        openSlide(
                          slide,
                        ),
                    child:
                    Padding(
                      padding:
                      const EdgeInsets
                          .all(
                        12,
                      ),
                      child:
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius
                                .circular(
                              10,
                            ),
                            child:
                            Image.asset(
                              slide.imagePath,
                              width:
                              90,
                              height:
                              90,
                              fit: BoxFit
                                  .cover,
                              errorBuilder:
                                  (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Container(
                                  width:
                                  90,
                                  height:
                                  90,
                                  color: Colors
                                      .grey
                                      .shade300,
                                  child:
                                  const Icon(
                                    Icons
                                        .image,
                                    size:
                                    40,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(
                            width:
                            15,
                          ),

                          Expanded(
                            child:
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  slide
                                      .title,
                                  style:
                                  const TextStyle(
                                    fontSize:
                                    18,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                  4,
                                ),

                                Text(
                                  slide
                                      .category,
                                  style:
                                  TextStyle(
                                    color:
                                    Colors.grey.shade700,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                  10,
                                ),

                                Text(
                                  "Completion: $progress%",
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                  6,
                                ),

                                LinearProgressIndicator(
                                  value: progress / 100.0,
                                ),

                                const SizedBox(
                                  height:
                                  8,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "$progress%",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                    10,
                                    vertical:
                                    4,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color: getStatusColor(
                                      progress,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  child:
                                  Text(
                                    getStatus(
                                      progress,
                                    ),
                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize:
                                      12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}