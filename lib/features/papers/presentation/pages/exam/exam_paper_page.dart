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
        ? "assets/papers/paper_1/exams/papers"
        : "assets/papers/paper_1/exams/memos";
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
            itemBuilder: (_, index) => _examTile(papers[index]),
          ),
        ],
      ),
    );
  }

  // ---------------- Tile ----------------
  Widget _examTile(ExamPaper paper) {
    final isSaved = _savedPapers.contains(paper);
    return GestureDetector(
      onTap: () => _openPdf(paper),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                paper.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSaved
                      ? _savedPapers.remove(paper)
                      : _savedPapers.add(paper);
                });
              },
              child: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? Colors.redAccent : Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
