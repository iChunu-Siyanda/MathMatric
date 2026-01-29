import 'package:flutter/material.dart';
import 'package:math_matric/features/auth/presentation/page/login_page.dart';
import 'package:math_matric/features/auth/presentation/page/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //Show Login Page
  bool showLoginPage = true;

  //Toggle between login And Register Page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(
        onRegisterTap: togglePages,
      );  
    }
    else{
      return RegisterPage(
        onLoginTap: togglePages,
      );
    }
  } 
}