import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/progress_service.dart';
import '../../../data/repositories/slide_repository.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {

  double overallProgress = 0;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final slides =
    await SlideRepository().getSlides();

    overallProgress =
    await ProgressService.getOverallProgress(
      slides.map((e) => e.id).toList(),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    final uid =
        FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(
          child: Text("Not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Profile"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
          snapshot.data!.data()
          as Map<String, dynamic>?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  data?['photoUrl'] != null &&
                      data!['photoUrl']
                          .toString()
                          .isNotEmpty
                      ? NetworkImage(
                      data['photoUrl'])
                      : null,
                  child:
                  data?['photoUrl'] == null
                      ? const Icon(
                    Icons.person,
                    size: 50,
                  )
                      : null,
                ),

                const SizedBox(height: 20),

                Text(
                  data?['displayName'] ??
                      'Student',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  data?['email'] ?? '',
                ),

                const SizedBox(height: 10),

                Text(
                  "Age: ${data?['age'] ?? 'N/A'}",
                ),

                const SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding:
                    const EdgeInsets.all(
                        16),
                    child: Column(
                      children: [

                        const Text(
                          "Overall Progress",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        LinearProgressIndicator(
                          value:
                          overallProgress /
                              100,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          "${overallProgress.toStringAsFixed(0)}%",
                        ),
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