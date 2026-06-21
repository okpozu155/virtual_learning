import 'package:flutter/material.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/auth_button.dart';
import '../controllers/auth_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  
  bool obscurePassword = true;

  // Theme Constants perfectly matching Login & Welcome flows
  static const Color slatePrimary = Color(0xFF3B5866);
  static const Color deepCharcoal = Color(0xFF0F172A);
  static const Color slateText = Color(0xFF64748B);
  static const Color premiumBg = Color(0xFFF8FAFC);

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
          content: Text("Account created successfully! You can log in now."),
          backgroundColor: Colors.green,
        ),
      );
      
      // Pops registration layer off navigation stack to reveal the login screen seamlessly
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
      backgroundColor: premiumBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: deepCharcoal), // Styled system back arrow
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
            child: ListenableBuilder(
              listenable: _authController,
              builder: (context, child) {
                return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Registration Header Glow Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: slatePrimary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          size: 48,
                          color: slatePrimary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Create Account", 
                        style: TextStyle(
                          fontSize: 32, 
                          fontWeight: FontWeight.w800, 
                          color: deepCharcoal,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Join our microbiology learning community", 
                        style: TextStyle(color: slateText, fontSize: 15),
                      ),
                      const SizedBox(height: 36),

                      // Full Name Field
                      AuthTextField(
                        controller: nameController,
                        label: "Full Name",
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        validator: (value) => value == null || value.isEmpty ? "Enter your name" : null,
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      AuthTextField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Enter email";
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) return "Enter valid email format";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      AuthTextField(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock_outline_rounded,
                        obscureText: obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSignup(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: slateText,
                          ),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                        validator: (value) => value == null || value.length < 6 ? "Minimum 6 characters" : null,
                      ),
                      const SizedBox(height: 40),

                      // Action Button
                      AuthButton(
                        text: "Sign Up",
                        onPressed: _handleSignup,
                        isLoading: _authController.isLoading,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}