import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/auth/auth_firebase.dart';
import 'package:math_matric/firebase_options.dart';
import 'package:math_matric/bloc/HabitBloc/habit_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HabitBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: AuthFirebase(),),
      ),
    );
  }
}
