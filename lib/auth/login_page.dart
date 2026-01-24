import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/auth/auth_components/auth_background.dart';
import 'package:math_matric/auth/auth_components/my_button.dart';
import 'package:math_matric/auth/auth_components/my_text_field.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onRegisterTap;

  const LoginPage({super.key, this.onRegisterTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signUserIn() async {
    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// LOGO
                      Center(
                        child: Image.asset(
                          'assets/images/x.png',
                          height: 64,
                        ),
                      ),
        
                      const SizedBox(height: 24),
        
                      /// TITLE
                      Text(
                        "Welcome Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                        ),
                      ),
        
                      const SizedBox(height: 6),
        
                      Text(
                        "Sign in to continue your maths journey",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
        
                      const SizedBox(height: 28),
        
                      /// EMAIL
                      MyTextField(
                        controller: emailController,
                        hint: "Email address",
                        obscure: false,
                      ),
        
                      const SizedBox(height: 16),
        
                      /// PASSWORD
                      MyTextField(
                        controller: passwordController,
                        hint: "Password",
                        obscure: true,
                      ),
        
                      const SizedBox(height: 12),
        
                      /// FORGOT PASSWORD
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1B6EF3),
                            ),
                          ),
                        ),
                      ),
        
                      const SizedBox(height: 24),
        
                      /// PREMIUM BUTTON
                      MyButton(
                        label: "Sign In",
                        isLoading: isLoading,
                        onPressed: signUserIn,
                      ),
        
                      const SizedBox(height: 28),
        
                      /// DIVIDER
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "or",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
        
                      const SizedBox(height: 22),
        
                      /// REGISTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New to MathMatric?",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: widget.onRegisterTap,
                            child: const Text(
                              "Create account",
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
