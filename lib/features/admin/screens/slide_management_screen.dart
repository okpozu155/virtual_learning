import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repositories/cloudinary_repository.dart';
import 'annotation_editor_screen.dart';
import 'hotspot_list_screen.dart';

class SlideManagementScreen extends StatefulWidget {
  const SlideManagementScreen({super.key});

  @override
  State<SlideManagementScreen> createState() =>
      _SlideManagementScreenState();
}

class _SlideManagementScreenState
    extends State<SlideManagementScreen> {
  final ImagePicker picker = ImagePicker();

  final CloudinaryRepository cloudinary =
  CloudinaryRepository();

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> uploadSlides() async {
    try {
      final images = await picker.pickMultiImage();

      if (images.isEmpty) return;

      for (final image in images) {
        try {
          final imageUrl = await cloudinary.uploadImage(
            File(image.path),
          );

          final slideId =
              image.name.split('.').first;

          await firestore
              .collection('slides')
              .doc(slideId)
              .set({
            'id': slideId,
            'title': image.name,
            'imageUrl': imageUrl,
            'category': '',
            'description': '',
            'createdAt':
            FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint(
            'Error uploading ${image.name}: $e',
          );
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slides uploaded successfully'),
        ),
      );
    } catch (e) {
      debugPrint('Upload failed: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
        ),
      );
    }
  }

  Widget _buildSlideImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(
        Icons.image,
        size: 50,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => const Icon(
          Icons.broken_image,
          size: 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Slide Management',
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: uploadSlides,
        child: const Icon(Icons.upload),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: uploadSlides,
                icon: const Icon(Icons.upload),
                label: const Text(
                  'Upload Images',
                ),
              ),
            ),
          ),

          Expanded(
            child:
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('slides')
                  .orderBy(
                'createdAt',
                descending: true,
              )
                  .snapshots(),
              builder:
                  (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No slides uploaded',
                    ),
                  );
                }

                final docs =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder:
                      (context, index) {
                    final slide =
                    docs[index].data()
                    as Map<String, dynamic>;

                    final slideId =
                        docs[index].id;

                    final imageUrl =
                        slide['imageUrl']
                            ?.toString() ??
                            '';

                    final title =
                        slide['title']
                            ?.toString() ??
                            'Untitled';

                    return Card(
                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.all(
                          12,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding:
                              EdgeInsets.zero,
                              leading:
                              _buildSlideImage(
                                imageUrl,
                              ),
                              title: Text(
                                title,
                              ),
                              subtitle: Text(
                                'ID: $slideId',
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child:
                                  ElevatedButton.icon(
                                    icon:
                                    const Icon(
                                      Icons
                                          .edit_location_alt,
                                    ),
                                    label:
                                    const Text(
                                      'Annotate',
                                    ),
                                    onPressed:
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                              AnnotationEditorScreen(
                                                slideId:
                                                slideId,
                                                imageUrl:
                                                imageUrl,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child:
                                  ElevatedButton.icon(
                                    icon:
                                    const Icon(
                                      Icons
                                          .place,
                                    ),
                                    label:
                                    const Text(
                                      'Hotspots',
                                    ),
                                    onPressed:
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                              HotspotListScreen(
                                                slideId:
                                                slideId,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}