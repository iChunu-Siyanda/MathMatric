import 'package:flutter/material.dart';

class ExamMemoPage extends StatelessWidget {
  final String pdfPath;

  const ExamMemoPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Exam Memo:\n$pdfPath",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
