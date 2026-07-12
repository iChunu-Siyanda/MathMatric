import 'package:flutter/material.dart';

class ClassNotesPage extends StatelessWidget {
  const ClassNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Notes:",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}