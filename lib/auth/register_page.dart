import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/auth/auth_components/auth_background.dart';
import 'package:math_matric/auth/auth_components/my_button.dart';
import 'package:math_matric/auth/auth_components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onLoginTap;

  const RegisterPage({super.key, this.onLoginTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> signUserUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      _showMessage("Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Registration failed");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/x.png', height: 64),

            const SizedBox(height: 24),

            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Start your maths success journey",
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 28),

            MyTextField(
              controller: emailController,
              hint: "Email address",
              obscure: false,
            ),

            const SizedBox(height: 16),

            MyTextField(
              controller: passwordController,
              hint: "Password",
              obscure: true,
            ),

            const SizedBox(height: 16),

            MyTextField(
              controller: confirmPasswordController,
              hint: "Confirm password",
              obscure: true,
            ),

            const SizedBox(height: 28),

            MyButton(
              label: "Create Account",
              isLoading: isLoading,
              onPressed: signUserUp,
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: widget.onLoginTap,
                  child: const Text(
                    "Sign in",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B6EF3),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
