import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router.dart';

class MathMatricApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MathMatricApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMatric',
      debugShowCheckedModeBanner: false,

      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings,prefs),
      initialRoute: Routes.initial,

      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}  
