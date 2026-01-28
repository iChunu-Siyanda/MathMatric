import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_state.dart';
import 'package:math_matric/app/navigation/section_context_modal.dart';
import 'package:math_matric/features/papers/presentation/widget/main/exam_paper_viewer.dart';

class ExamPaperPage extends StatefulWidget {
  final SectionContext contextData;
  final ExamPageMode mode;
  final PaperType paperType;

  const ExamPaperPage({
    super.key,
    required this.contextData,
    required this.mode,
    required this.paperType,
  });

  @override
  State<ExamPaperPage> createState() => _ExamPaperPageState();
}

class _ExamPaperPageState extends State<ExamPaperPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;

  final Set<ExamPaper> _savedPapers = {};

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

    context.read<ExamBloc>().add(ExamPaperRequested(widget.paperType));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openPdf(ExamPaper paper) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamPaperViewer(
          title: isPaper ? paper.title : "${paper.title} – Memo",
          pdfAssetPath: isPaper
              ? paper.assetPath
              : paper.assetPath, // replace with memoAssetPath later
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(builder: (context, state){
      if (state is ExamPaperLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is ExamPaperLoaded) {
        final examPapers = state.examPapers;

        return FadeTransition(
          opacity: _fadeAnim,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: examPapers.entries
                .expand(
                  (entry) => [
                    _sessionHeader(entry.key.name),
                    const SizedBox(height: 12),
                    ...entry.value.map(_documentCard),
                    const SizedBox(height: 24),
                  ],
                )
                .toList(),
          ),
        );
      }

      if (state is ExamPaperError) {
        return Center(child: Text(state.message));
      }

      return const SizedBox.shrink();
    });
  }

  Widget _documentCard(ExamPaper paper) {
    final isSaved = _savedPapers.contains(paper);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _openPdf(paper),
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
                if (isPaper) _saveButton(paper, isSaved),
                _bottomGradient(),
                _titleAndButton(paper),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton(ExamPaper paper, bool isSaved) {
    return Positioned(
      top: 12,
      right: 12,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSaved ? _savedPapers.remove(paper) : _savedPapers.add(paper);
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

  Widget _titleAndButton(ExamPaper paper) {
    return Positioned(
      bottom: 18,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPaper ? paper.title : "${paper.title} – Memo",
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
}
