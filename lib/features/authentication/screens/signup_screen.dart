import 'package:flutter/material.dart';
<<<<<<< HEAD
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
          content: Text("Account Created successfully! You can log in now."),
          backgroundColor: Colors.green,
        ),
      );
      
      // Pops the registration off navigation stack to reveal the login underlay seamlessly
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
=======
import 'login_screen.dart';
import '../../../core/utils/validators.dart';
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
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
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
          content: Text('Account created successfully'),
        ),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Signup failed',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // ==================== UPDATED HELPER WIDGET ====================
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
        fillColor: const Color.fromARGB(255, 140, 133, 236), // FIXED: Changed from yellow hex to light gray
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Optional: removes the black outline border for a cleaner look
        ),
      ),
    );
  }
  // ==============================================================
>>>>>>> okpozu_branch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
=======
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),



      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 20),

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

            const SizedBox(height: 25),

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

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign In",
                  ),
                ),
              ],
            ),
          ],
>>>>>>> okpozu_branch
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
>>>>>>> okpozu_branch
}