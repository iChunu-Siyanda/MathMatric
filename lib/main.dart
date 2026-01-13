import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/auth/auth_firebase.dart';
import 'package:math_matric/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 78, 169, 207),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color.fromARGB(255, 78, 169, 207), 
          secondary: Colors.white,            
          tertiary: const Color(0xFF39FF14), 
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 14, 38),
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF000B1E),   // Deep Navy
          tertiary: const Color(0xFF39FF14),  // Neon Green accent
        )
      ),
      themeMode: ThemeMode.system,
      home: Scaffold(body: AuthFirebase(),),
    );
  }
}
