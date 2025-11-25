import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/auth/forgot_password_page.dart';
import 'package:math_matric/auth/auth_components/my_button.dart';
import 'package:math_matric/auth/auth_components/my_text.dart';
import 'package:math_matric/auth/auth_components/show_invalid_msg.dart';
import 'package:math_matric/auth/auth_components/square_tile.dart';

class LoginPage extends StatefulWidget {
  final void Function()? loginBtn;

  const LoginPage({super.key, required this.loginBtn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign in user
  void signUserIn() async {
    //Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    //try to sign in user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //pop circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showInvalidMsg(context, e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Image logo
              Image.asset('assets/images/x.png', height: 60),

              SizedBox(height: 10.0),

              //welcome back message
              Text(
                "Welcome Back! You've been missed",
                style: TextStyle(color: Colors.grey[800]),
              ),

              SizedBox(height: 10.0),

              //Username & Password textField
              MyText(
                controller: emailController,
                obscure: false,
                hint: "Email",
              ),

              SizedBox(height: 10.0),

              MyText(
                controller: passwordController,
                obscure: true,
                hint: "Password",
              ),

              SizedBox(height: 5.0),

              //Forgot password link
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPasswordPage();
                            }
                          )
                        );
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0),

              //Sign in button
              Padding(
                padding: const EdgeInsets.all(23.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButton(onTapBtn: signUserIn, message: "Sign In"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.0),

              //Or continue with other platforms
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 30),

                  // Left line
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),

                  // Text in the middle
                  Text(
                    "Or Continue With",
                    style: TextStyle(color: Colors.grey[800]),
                  ),

                  // Right line
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),

                  SizedBox(width: 30),
                ],
              ),

              SizedBox(height: 15.0),

              //Google & Apple Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Google Login
                  GestureDetector(
                    child: SquareTile(imagePath: "assets/images/google.png"),
                  ),

                  SizedBox(width: 10.0),

                  //Apple Login
                  GestureDetector(
                    child: SquareTile(imagePath: "assets/images/apple.png"),
                  ),
                ],
              ),

              SizedBox(height: 15.0),

              //Register Account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Registered Yet?",
                    style: TextStyle(color: Colors.grey[800]),
                  ),

                  SizedBox(width: 5.0),

                  GestureDetector(
                    onTap: widget.loginBtn,
                    child: Text(
                      "Registered Now",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
