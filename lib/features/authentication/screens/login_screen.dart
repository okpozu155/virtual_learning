import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import 'forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() => loading = true);

      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Login failed",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void showForgotPasswordDialog() {
    final resetEmailController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Reset Password",
          ),
          content: TextFormField(
            controller: resetEmailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(
                    email: resetEmailController.text
                        .trim(),
                  );

                  if (!mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password reset email sent",
                      ),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        e.message ??
                            "Failed to send reset email",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 22,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Welcome Back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "Login to continue your learning",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                TextFormField(
                  controller:
                  emailController,
                  validator:
                  Validators.validateEmail,
                  decoration:
                  const InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    filled: true,
                    fillColor: Color.fromARGB(
                      255,
                      155,
                      218,
                      149,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextFormField(
                  controller:
                  passwordController,
                  obscureText: true,
                  validator:
                  Validators.validatePassword,
                  decoration:
                  const InputDecoration(
                    labelText: "Password",
                    hintText: "Password",
                    filled: true,
                    fillColor: Color.fromARGB(
                      255,
                      155,
                      218,
                      149,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                    loading ? null : login,
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                      "Login",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}