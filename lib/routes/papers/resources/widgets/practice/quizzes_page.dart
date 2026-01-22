import 'package:flutter/material.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Question Paper: Practice Quizzes",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}