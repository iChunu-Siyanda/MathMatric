import 'package:flutter/material.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Question Paper: practice",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}