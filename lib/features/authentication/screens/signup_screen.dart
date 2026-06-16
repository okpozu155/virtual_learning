import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../../../core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> signUp() async {
    if (_passwordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }

    try {
      setState(() => loading = true);

      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully"),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Signup failed"),
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Widget buildField(
      TextEditingController controller,
      IconData icon,
      String hint,
      bool obscure,
      ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xffF5E7B2),
        hintText: hint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 40),

            buildField(
              _nameController,
              Icons.person_outline,
              "Full Name",
              false,
            ),

            const SizedBox(height: 15),

            buildField(
              _emailController,
              Icons.email_outlined,
              "Email",
              false,
            ),

            const SizedBox(height: 15),

            buildField(
              _passwordController,
              Icons.lock_outline,
              "Password",
              true,
            ),

            const SizedBox(height: 15),

            buildField(
              _confirmPasswordController,
              Icons.lock_outline,
              "Confirm Password",
              true,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : signUp,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}