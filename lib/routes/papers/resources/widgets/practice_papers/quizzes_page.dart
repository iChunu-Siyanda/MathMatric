import 'package:flutter/material.dart';

class QuizzesPage extends StatefulWidget {
  final String pdfPath;
  const QuizzesPage({super.key, required this.pdfPath});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Question Paper:\n${widget.pdfPath}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}