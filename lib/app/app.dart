import 'package:flutter/material.dart';
import 'router.dart';

class MathMatricApp extends StatelessWidget {
  const MathMatricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMatric',
      debugShowCheckedModeBanner: false,

      // Navigation
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: Routes.initial,

      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}

//This answers what kind of app is this?
