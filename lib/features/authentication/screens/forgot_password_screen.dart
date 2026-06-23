import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final emailController =
  TextEditingController();

  bool loading = false;

  Future<void> resetPassword() async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Password reset email sent.",
          ),
        ),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                "Something went wrong",
          ),
        ),
      );

    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
        ),
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller:
              emailController,
              decoration:
              const InputDecoration(
                labelText:
                "Email Address",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                loading
                    ? null
                    : resetPassword,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Send Reset Email",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}