import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/models/exam_paper_model.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_paper_viewer.dart';

class ExamPaperPage extends StatefulWidget {
  final ExamPaperModel pdfPath;
  final ExamPaperModel pdfTitle;

  const ExamPaperPage({super.key, required this.pdfPath, required this.pdfTitle});

  @override
  State<ExamPaperPage> createState() => _ExamPaperPageState();
}

class _ExamPaperPageState extends State<ExamPaperPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSave() {
    setState(() => isSaved = !isSaved);
  }

  void _openPdf() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Opening question paper...")));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamPaperViewer(
          title: widget.pdfTitle.title,
          pdfAssetPath: widget.pdfPath.assetPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [_previewCard()],
      ),
    );
  }

  Widget _previewCard() {
    return GestureDetector(
      onTap: _openPdf,
      child: Container(
        height: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              spreadRadius: -2,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // PDF
              Positioned.fill(
                child: Image.asset(
                  "assets/images/calculus.jpg",
                  fit: BoxFit.cover,
                ),
              ),

              // FAVORITE BUTTON
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: _toggleSave,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_outline,
                      color: isSaved ? Colors.redAccent : Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),

              // BOTTOM GRADIENT + BUTTON
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.45),
                        Colors.black.withValues(alpha: 0.80),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // VIEW BUTTON
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "View Paper",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
