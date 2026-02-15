import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/app/navigation/section_context_modal.dart';
import 'package:math_matric/features/papers/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_state.dart';
import 'package:math_matric/features/papers/presentation/widget/main/exam_paper_viewer.dart';

class ExamPaperPage extends StatefulWidget {
  final SectionContext contextData;
  final ExamPageMode mode;
  final String? paperId;
  const ExamPaperPage({
    super.key,
    required this.contextData,
    required this.mode,
    this.paperId,
  });
  @override
  State<ExamPaperPage> createState() => _ExamPaperPageState();
}

class _ExamPaperPageState extends State<ExamPaperPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;

  final Set<ExamPaper> _savedPapers = {};

  //Convenience getter to know if this page represents the main exam paper or the memo tab.
  bool get isPaper => widget.mode == ExamPageMode.paper;

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

    context.read<ExamBloc>().add(
          ExamPaperFocusRequested(
            widget.paperId!,
            widget.contextData.paperType,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Opens the selected PDF.
  void _openPdf(ExamPaper document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamPaperViewer(
          title: document.title,
          pdfAssetPath: document.assetPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state is ExamPaperLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ExamPaperFocusLoaded) {
          final ExamPaper selectedDocument = isPaper ? state.paper : state.memo;

          return FadeTransition(
            opacity: _fadeAnim,
            child: _documentCard(selectedDocument),
          );
        }

        if (state is ExamPaperError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _documentCard(ExamPaper document) {
    final isSaved = _savedPapers.contains(document);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _openPdf(document),
        child: Container(
          height: isPaper ? 320 : 300,
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
                Positioned.fill(
                  child: Image.asset(
                    isPaper
                        ? "assets/images/trig_img.jpg"
                        : "assets/images/calculus.jpg",
                    fit: BoxFit.cover,
                  ),
                ),

                if (isPaper) _saveButton(document, isSaved),

                _bottomGradient(),
                _titleAndButton(document),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton(ExamPaper document, bool isSaved) {
    return Positioned(
      top: 12,
      right: 12,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSaved
                ? _savedPapers.remove(document)
                : _savedPapers.add(document);
          });
        },
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
    );
  }

  Widget _bottomGradient() {
    return Align(
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
    );
  }

  Widget _titleAndButton(ExamPaper document) {
    return Positioned(
      bottom: 18,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            document.title,
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
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              isPaper ? "View Paper" : "View Memo",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
