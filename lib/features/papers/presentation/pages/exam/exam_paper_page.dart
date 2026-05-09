import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/app/navigation/section_context_modal.dart';
import 'package:math_matric/features/papers/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_state.dart';
import 'package:math_matric/features/papers/presentation/pages/exam/exam_paper_viewer.dart';
import 'package:math_matric/features/papers/presentation/widget/main/exam_tile.dart';

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

class _ExamPaperPageState extends State<ExamPaperPage> {
  final Set<ExamPaper> _savedPapers = {};

  bool get isPaper => widget.mode == ExamPageMode.paper;

  @override
  void initState() {
    super.initState();

    context.read<ExamBloc>().add(
          ExamPaperRequested(widget.contextData.paperType, widget.contextData.session, widget.contextData.year),
        );
  }

  List<String> buildPages(String assetPath, int pageCount) {
    final basePath = widget.mode == ExamPageMode.paper
        ? "papers/paper_1/exams/papers"
        : "papers/paper_1/exams/memos";
    return List.generate(
      pageCount,
      (index) => "$basePath/$assetPath/p${index + 1}.webp",
    );
  }

  void _openPdf(ExamPaper document) {
    final pages = buildPages(document.assetPath, document.pageCount);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamPaperViewer(
          title: document.title,
          pageAssets: pages,
        ),
      ),
    );
  }

   Animation<double> _itemInterval(int index) {
    final start = (index * _staggerMs) / _controller.duration!.inMilliseconds;
    final end = ((index * _staggerMs) + (_staggerMs + 150)) /
        _controller.duration!.inMilliseconds;

    return CurvedAnimation(
      parent: _controller,
      curve:
          Interval(start.clamp(0, 1), end.clamp(0, 1), curve: Curves.easeOut),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state is ExamPaperLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExamPaperError) {
          return Center(child: Text(state.message));
        }

        if (state is ExamPaperListLoaded) {
          final filteredSections = state.sections.map((key, papers) {
            final filtered = papers.where((p) {
              return isPaper ? !p.isMemo : p.isMemo;
            }).toList();

            return MapEntry(key, filtered);
          });

          return ListView(
            children: filteredSections.entries
                .where((entry) => entry.value.isNotEmpty)
                .map((entry) => _section(entry.key, entry.value))
                .toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ---------------- Section ----------------
  Widget _section(String title, List<ExamPaper> papers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: papers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.6,
            ),
            itemBuilder: (_, index) => ExamTile(papers[index]),
          ),

                  SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final anima = _itemInterval(index);

              return AnimatedBuilder(
                animation: anima,
                builder: (_, child) => Opacity(
                  opacity: anima.value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - anima.value) * 18),
                    child: child,
                  ),
                ),
                child: ExamTile(papers[index]),
              );
            },
            childCount: papers.length,
          ),
        ),
        ],
      ),
    );
  }
}
