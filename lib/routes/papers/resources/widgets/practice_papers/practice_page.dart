import 'package:flutter/material.dart';

class PracticePage extends StatefulWidget {
  final String pdfPath;
  const PracticePage({super.key, required this.pdfPath});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
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