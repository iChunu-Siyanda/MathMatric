import 'package:flutter/material.dart';

class ExamPaperPage extends StatelessWidget {
  final String pdfPath;

  const ExamPaperPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Question Paper:\n$pdfPath",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
