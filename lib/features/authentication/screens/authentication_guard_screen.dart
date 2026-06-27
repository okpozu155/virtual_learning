import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/admin/screens/admin_dashboard_screen.dart';

const Set<String> adminEmails = {'virtualmicroscopy26@gmail.com', 'aa@g.com'};

class AdminGuard extends StatelessWidget {
  const AdminGuard({super.key});

  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    final email = user.email?.trim().toLowerCase();

    if (email != null && adminEmails.contains(email)) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data()?['role'] == 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const AdminDashboardScreen();
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Access Denied")),
          body: const Center(
            child: Text(
              "You do not have permission to access this page.",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
