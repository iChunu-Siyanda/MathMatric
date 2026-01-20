import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/paper_1/data/exam_paper.dart';
import 'package:math_matric/routes/papers/resources/models/exam_paper_model.dart';
import 'package:math_matric/routes/papers/resources/models/section_context_modal.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_paper_viewer.dart';

class ExamMemoPage extends StatefulWidget {
  const ExamMemoPage({super.key, required SectionContext contextData});

  @override
  State<ExamMemoPage> createState() => _ExamMemoPageState();
}

class _ExamMemoPageState extends State<ExamMemoPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openMemo(ExamPaperModel paper) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamPaperViewer(
          title: "${paper.title} – Memo",
          pdfAssetPath: paper.assetPath//paper.memoAssetPath, when you created memo path
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final papersBySession = ExamPaperRepository.papers;

    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: papersBySession.entries
            .expand(
              (entry) => [
                _sessionHeader(entry.key.name),
                const SizedBox(height: 12),
                ...entry.value.map(_memoCard),
                const SizedBox(height: 24),
              ],
            )
            .toList(),
      ),
    );
  }

  Widget _sessionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _memoCard(ExamPaperModel paper) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _openMemo(paper),
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                spreadRadius: -4,
                offset: const Offset(0, 8),
                color: Colors.black.withValues(alpha: 0.18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/calculus.jpg",
                    fit: BoxFit.cover,
                  ),
                ),

                // Gradient
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.45),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Title + Button
                Positioned(
                  bottom: 18,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${paper.title} – Memo",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "View Memo",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
