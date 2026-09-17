import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/auth/presentation/navigation/login_or_register.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class AuthFirebase extends StatelessWidget {
  const AuthFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>( 
        stream: FirebaseAuth.instance.authStateChanges(), //Stream checks if user is logged in or not
        builder: (context,snapshot) {
          //Home page if user logged in
          if (snapshot.hasData){
            // Trigger GoRouter to navigate to the shell route
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go(Routes.home);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
            
          }

          //Login or register if user not logged in
          else{
            return LoginOrRegister();
          }
        }
      ),
    );
  }
}