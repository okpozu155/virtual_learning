import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/auth_button.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  
  bool obscurePassword = true;

  // Theme Constants matching the Onboarding flow
  static const Color slatePrimary = Color(0xFF3B5866);
  static const Color deepCharcoal = Color(0xFF0F172A);
  static const Color slateText = Color(0xFF64748B);
  static const Color premiumBg = Color(0xFFF8FAFC);

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.login(
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful! Welcome back."),
          backgroundColor: Colors.green,
        ),
      );
      // 🛫 Seamlessly forwards user straight into the main dashboard route
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authController.errorMessage ?? "Login Failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final user = await _authController.loginWithGoogle();
    
    if (!mounted) return;

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Login Successful! Welcome $user"),
          backgroundColor: slatePrimary,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authController.errorMessage ?? "Google Request Cancelled"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleForgotPassword() async {
    final dialogEmailController = TextEditingController(text: emailController.text);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: premiumBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Reset Password",
            style: TextStyle(color: deepCharcoal, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your account email below. We will send a secure password reset link to your inbox.",
                style: TextStyle(color: slateText, fontSize: 14, height: 1.3),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dialogEmailController,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: const TextStyle(color: slateText),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: slatePrimary, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined, color: slatePrimary),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: slateText, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: slatePrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () async {
                final targetEmail = dialogEmailController.text.trim();
                if (targetEmail.isEmpty) return;
                
                Navigator.pop(context);
                
                final success = await _authController.forgotPassword(targetEmail);
                
                if (!mounted) return;
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password reset link sent! Check your inbox."),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_authController.errorMessage ?? "Error sending reset link"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Send Link", style: TextStyle(color: Colors.white)),
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
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
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
                      // Branding Icon Container with Studio Glow
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: slatePrimary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.biotech_rounded,
                          size: 48,
                          color: slatePrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32, 
                          fontWeight: FontWeight.w800, 
                          color: deepCharcoal,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Login to continue learning microbiology", 
                        style: TextStyle(color: slateText, fontSize: 15),
                      ),
                      const SizedBox(height: 36),

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

                      AuthTextField(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        obscureText: obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: slateText,
                          ),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                        validator: (value) => value == null || value.length < 6 ? "Minimum 6 characters" : null,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _handleForgotPassword, 
                          style: TextButton.styleFrom(foregroundColor: slatePrimary),
                          child: const Text(
                            "Forgot Password?", 
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      AuthButton(
                        text: "Login",
                        onPressed: _handleLogin,
                        isLoading: _authController.isLoading,
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(child: Divider(color: const Color(0xFFE2E8F0), thickness: 1)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Or continue with", style: TextStyle(color: slateText, fontSize: 14)),
                          ),
                          Expanded(child: Divider(color: const Color(0xFFE2E8F0), thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            icon: const Icon(Icons.g_mobiledata, size: 34, color: Colors.red),
                            label: const Text(
                              "Sign in with Google", 
                              style: TextStyle(color: deepCharcoal, fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            onPressed: _handleGoogleLogin,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: slateText, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                            style: TextButton.styleFrom(foregroundColor: slatePrimary),
                            child: const Text(
                              "Sign Up", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
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