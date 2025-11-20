import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/auth/compnents/my_button.dart';
import 'package:math_matric/auth/compnents/my_text.dart';
import 'package:math_matric/auth/compnents/show_invalid_msg.dart';


class RegisterPage extends StatefulWidget {
  final Function()? registerBtn;

  const RegisterPage({super.key, required this.registerBtn});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Sign up user
  void signUserUp() async {
    //Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Check if passwords match
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pop(context); // close loading circle
      } else {
        Navigator.pop(context); // close loading circle
        showInvalidMsg(context, "Passwords do not match. Please try again.");
        return; // stop execution
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // close loading circle
      showInvalidMsg(context, e.code); // show error
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
              Image.asset('lib/images/x.png', height: 60),

              SizedBox(height: 10.0),

              //welcome back message
              Text(
                "Welcome! Sign Up Your New Account",
                style: TextStyle(color: Colors.grey[800]),
              ),

              SizedBox(height: 10.0),

              //Username, Password, and Confirm Password textField
              MyText(
                controller: emailController,
                obscure: false,
                hint: "Username",
              ),

              SizedBox(height: 10.0),

              MyText(
                controller: passwordController,
                obscure: true,
                hint: "Password",
              ),

              SizedBox(height: 10.0),

              MyText(
                controller: confirmPasswordController,
                obscure: true,
                hint: "Confirm Password",
              ),

              SizedBox(height: 5.0),

              //Sign in button
              Padding(
                padding: const EdgeInsets.all(23.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButton(onTapBtn: signUserUp, message: "Sign Up"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.0),

              //Already Have Account? Back To Login Page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have Account?",
                    style: TextStyle(color: Colors.grey[800]),
                  ),

                  SizedBox(width: 5.0),

                  GestureDetector(
                    onTap: widget.registerBtn,
                    child: Text(
                      "Login Now",
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
