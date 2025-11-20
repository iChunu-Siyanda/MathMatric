import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/auth/auth_firebase.dart';
import 'package:math_matric/firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AuthFirebase(),
      ),
    );
  }
}
