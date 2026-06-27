import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/progress_service.dart';
import '../../../data/repositories/cloudinary_repository.dart';
import '../../../data/repositories/slide_repository.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final CloudinaryRepository _cloudinaryRepository = CloudinaryRepository();

  double overallProgress = 0;
  bool savingProfile = false;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final slides = await SlideRepository().getSlides();

    overallProgress = await ProgressService.getOverallProgress(
      slides.map((e) => e.id).toList(),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _editProfile(Map<String, dynamic>? data) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final nameController = TextEditingController(
      text: (data?['name'] ?? data?['displayName'] ?? user.displayName ?? '')
          .toString(),
    );
    final ageController = TextEditingController(
      text: (data?['age'] ?? '').toString(),
    );

    XFile? selectedImage;

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Edit Profile"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: selectedImage != null
                        ? FileImage(File(selectedImage!.path))
                        : _profileImageProvider(data),
                    child:
                        selectedImage == null &&
                            _profileImageProvider(data) == null
                        ? const Icon(Icons.person, size: 42)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final image = await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );

                      if (image == null) return;

                      setDialogState(() {
                        selectedImage = image;
                      });
                    },
                    icon: const Icon(Icons.photo_camera),
                    label: const Text("Choose Photo"),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    textCapitalization: TextCapitalization.words,
                  ),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: "Age",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );

    final name = nameController.text.trim();
    final age = ageController.text.trim();

    nameController.dispose();
    ageController.dispose();

    if (saved != true) {
      return;
    }

    if (!mounted) return;

    setState(() {
      savingProfile = true;
    });

    try {
      String? photoUrl = data?['photoUrl']?.toString();

      if (selectedImage != null) {
        photoUrl = await _cloudinaryRepository.uploadImage(
          File(selectedImage!.path),
        );
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name.isEmpty ? 'Student' : name,
        'displayName': name.isEmpty ? 'Student' : name,
        'age': age,
        'dateOfBirth': FieldValue.delete(),
        'photoUrl': photoUrl ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updateDisplayName(name.isEmpty ? 'Student' : name);

      if (photoUrl != null && photoUrl.isNotEmpty) {
        await user.updatePhotoURL(photoUrl);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile updated")));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile update failed: $e")));
    } finally {
      if (mounted) {
        setState(() {
          savingProfile = false;
        });
      }
    }
  }

  ImageProvider? _profileImageProvider(Map<String, dynamic>? data) {
    final photoUrl = data?['photoUrl']?.toString();

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return NetworkImage(photoUrl);
    }

    final authPhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;

    if (authPhotoUrl != null && authPhotoUrl.isNotEmpty) {
      return NetworkImage(authPhotoUrl);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(body: Center(child: Text("Not logged in")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final imageProvider = _profileImageProvider(data);
          final displayName =
              (data?['name'] ?? data?['displayName'] ?? 'Student').toString();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),

                const SizedBox(height: 20),

                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(data?['email'] ?? ''),

                const SizedBox(height: 10),

                Text("Age: ${data?['age'] ?? 'N/A'}"),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: savingProfile ? null : () => _editProfile(data),
                    icon: savingProfile
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.edit),
                    label: Text(savingProfile ? "Saving..." : "Edit Profile"),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Overall Progress",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        LinearProgressIndicator(
                          value: (overallProgress / 100).clamp(0.0, 1.0),
                        ),

                        const SizedBox(height: 10),

                        Text("${overallProgress.toStringAsFixed(0)}%"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
