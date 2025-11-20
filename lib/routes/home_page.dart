import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/routes/drawer_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  Matrix4 translateMatrix(double x, double y) {
    return Matrix4.identity()..setTranslationRaw(x, y, 0);
  }

  Matrix4 scaleMatrix(double s) {
    return Matrix4.diagonal3Values(s, s, 1);
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){ 
            setState(() {
              xOffset = 290;
              yOffset = 80;
              isDrawerOpen = true;
            });
          }, icon: Icon(Icons.menu)),
    
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
        ],
      ),
      
      body: Stack(
        children:[ 
          animatedContainer(),
          DrawerScreen(),
        ],
      ),
    );
  }

  AnimatedContainer animatedContainer() {
    return AnimatedContainer(
          transform: Matrix4.identity()
            ..multiply(translateMatrix(xOffset, yOffset))
            ..multiply(scaleMatrix(isDrawerOpen ? 0.85 : 1))
            ..rotateZ(isDrawerOpen ? -50 * math.pi / 180 : 0),
          duration: Duration(milliseconds: 200),
          color: Colors.white,
          decoration: BoxDecoration(
            borderRadius: isDrawerOpen
                ? BorderRadius.circular(40)
                : BorderRadius.circular(0),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Text(
                "You are now logged in ${user.email!}",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        );
  }
}
