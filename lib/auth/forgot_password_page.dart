import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/auth/auth_components/auth_background.dart';
import 'package:math_matric/auth/auth_components/my_button.dart';
import 'package:math_matric/auth/auth_components/my_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  Future<void> resetPassword() async {
    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset link sent to your email"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Enter your email and we’ll send you a reset link",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 28),

            MyTextField(
              controller: emailController,
              hint: "Email address",
              obscure: false,
            ),

            const SizedBox(height: 28),

            MyButton(
              label: "Send Reset Link",
              isLoading: isLoading,
              onPressed: resetPassword,
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Back to login",
                style: TextStyle(color: Color(0xFF1B6EF3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
