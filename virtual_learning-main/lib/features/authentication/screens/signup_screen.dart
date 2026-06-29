import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/validators.dart';
import '../../../core/routes/app_routes.dart';
import 'authentication_guard_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool loading = false;

  Future<void> signUp(BuildContext formContext) async {
    if (!Form.of(formContext).validate()) {
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      setState(() => loading = true);

      final email = _emailController.text.trim().toLowerCase();
      final role = adminEmails.contains(email) ? 'admin' : 'student';

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      final userId = credential.user!.uid;

      // Save user profile
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': _nameController.text.trim(),
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Create progress document
      await FirebaseFirestore.instance.collection('progress').doc(userId).set({
        'slidesViewed': 0,
        'quizzesTaken': 0,
        'averageScore': 0,
        'streakDays': 0,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Widget buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required bool obscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color.fromARGB(255, 155, 218, 149),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          child: Builder(
            builder: (formContext) {
              return Column(
                children: [
                  const SizedBox(height: 20),

                  buildField(
                    controller: _nameController,
                    icon: Icons.person_outline,
                    hint: "Full Name",
                    obscure: false,
                    validator: Validators.validateName,
                  ),

                  const SizedBox(height: 15),

                  buildField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hint: "Email",
                    obscure: false,
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 15),

                  buildField(
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    hint: "Password",
                    obscure: true,
                    validator: Validators.validatePassword,
                  ),

                  const SizedBox(height: 15),

                  buildField(
                    controller: _confirmPasswordController,
                    icon: Icons.lock_outline,
                    hint: "Confirm Password",
                    obscure: true,
                    validator: Validators.validatePassword,
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : () => signUp(formContext),
                      child: loading
                          ? const CircularProgressIndicator()
                          : const Text("Sign Up"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                        child: const Text("Sign In"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
