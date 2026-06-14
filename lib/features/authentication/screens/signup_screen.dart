import 'package:flutter/material.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/auth_button.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final AuthController _authController = AuthController();
  bool obscurePassword = true;

  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.signUp(
      nameController.text.trim(),
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created successfully! Please log in."),
          backgroundColor: Colors.green,
        ),
      );
      
      // 🚀 The Magic Link: Automatically returns back to the login screen!
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authController.errorMessage ?? "Registration Failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListenableBuilder(
            listenable: _authController,
            builder: (context, child) {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Create Account", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Join our microbiology learning community", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 40),

                    AuthTextField(
                      controller: nameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (value) => value == null || value.isEmpty ? "Enter your name" : null,
                    ),
                    const SizedBox(height: 20),

                    AuthTextField(
                      controller: emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) => value == null || !value.contains('@') ? "Enter valid email" : null,
                    ),
                    const SizedBox(height: 20),

                    AuthTextField(
                      controller: passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSignup(),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                      validator: (value) => value == null || value.length < 6 ? "Minimum 6 characters" : null,
                    ),
                    const SizedBox(height: 40),

                    AuthButton(
                      text: "Sign Up",
                      onPressed: _handleSignup,
                      isLoading: _authController.isLoading,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}