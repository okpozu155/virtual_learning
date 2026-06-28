import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../annotation/screens/annotation_designer_screen.dart';
import '../../../data/repositories/cloudinary_repository.dart';
import '../../../data/repositories/slide_repository.dart';

class SlideManagementScreen extends StatefulWidget {
  const SlideManagementScreen({super.key});

  @override
  State<SlideManagementScreen> createState() => _SlideManagementScreenState();
}

class _SlideManagementScreenState extends State<SlideManagementScreen> {
  final ImagePicker picker = ImagePicker();

  final CloudinaryRepository cloudinary = CloudinaryRepository();

  final SlideRepository slideRepository = SlideRepository();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadSlides() async {
    try {
      final images = await picker.pickMultiImage();

      if (images.isEmpty) return;

      for (final image in images) {
        try {
          final imageUrl = await cloudinary.uploadImage(File(image.path));

          final slideId = image.name.split('.').first;

          await firestore.collection('slides').doc(slideId).set({
            'id': slideId,
            'title': image.name,
            'imageUrl': imageUrl,
            'category': '',
            'description': '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint("Error uploading ${image.name}: $e");
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Slides uploaded successfully")),
      );
    } catch (e) {
      debugPrint("Upload failed: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }

  Future<void> _confirmDelete({
    required String slideId,
    required String title,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Slide"),
        content: Text("Delete '$title'?\n\nThis action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (result != true) return;

    try {
      await slideRepository.deleteSlide(slideId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$title deleted")));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete failed: $e")));
    }
  }

  Future<void> _editSlideDescription({
    required String slideId,
    required String title,
    required String currentDescription,
  }) async {
    final descriptionController = TextEditingController(
      text: currentDescription,
    );

    final description = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Slide Description"),
        content: TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: title,
            hintText: "Enter the information students should see.",
            border: const OutlineInputBorder(),
          ),
          maxLines: 6,
          textInputAction: TextInputAction.newline,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, descriptionController.text.trim());
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    descriptionController.dispose();

    if (description == null) return;

    try {
      await firestore.collection('slides').doc(slideId).update({
        'description': description,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Description saved for $title")));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Description save failed: $e")));
    }
  }

  Widget _buildSlideImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.image, size: 50);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Icon(Icons.broken_image, size: 50);
        },
      ),
    );
  }

  void _openAnnotationDesigner({
    required String slideId,
    required String imageUrl,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AnnotationDesignerScreen(slideId: slideId, imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slide Management")),
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
                label: const Text("Upload Images"),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('slides')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No slides uploaded"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final slide = docs[index].data() as Map<String, dynamic>;

                    final slideId = docs[index].id;

                    final imageUrl = slide['imageUrl']?.toString() ?? '';

                    final title = slide['title']?.toString() ?? 'Untitled';

                    final description = slide['description']?.toString() ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: _buildSlideImage(imageUrl),
                              title: Text(title),
                              subtitle: Text("ID: $slideId"),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "delete") {
                                    _confirmDelete(
                                      slideId: slideId,
                                      title: title,
                                    );
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                _editSlideDescription(
                                  slideId: slideId,
                                  title: title,
                                  currentDescription: description,
                                );
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: "Slide Description",
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  description.isEmpty
                                      ? "Tap to add slide information"
                                      : description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.description_outlined),
                                label: const Text("Edit Slide Description"),
                                onPressed: () {
                                  _editSlideDescription(
                                    slideId: slideId,
                                    title: title,
                                    currentDescription: description,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.edit_location_alt),
                                label: const Text("Annotate Slide"),
                                onPressed: () {
                                  _openAnnotationDesigner(
                                    slideId: slideId,
                                    imageUrl: imageUrl,
                                  );
                                },
                              ),
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
