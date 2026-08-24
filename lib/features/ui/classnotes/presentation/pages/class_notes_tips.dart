import 'package:flutter/material.dart';

class ClassNotesTips extends StatelessWidget {
  const ClassNotesTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Notes:Tips",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}