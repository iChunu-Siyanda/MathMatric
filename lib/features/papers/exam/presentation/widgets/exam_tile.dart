import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/exam/presentation/pages/exam_paper_viewer.dart';

class ExamTile extends StatefulWidget {
  final ExamPaper paper;
  final ExamPageMode paperMode;
  final Set<ExamPaper> savedPapers;
  final VoidCallback? onBookmarkToggle; // Added callback to ensure state refreshes safely

  const ExamTile({
    super.key,
    required this.paper,
    required this.savedPapers,
    required this.paperMode,
    this.onBookmarkToggle,
  });

  @override
  State<ExamTile> createState() => _ExamTileState();
}

class _ExamTileState extends State<ExamTile> {
  @override
  Widget build(BuildContext context) {
    final isSaved = widget.savedPapers.contains(widget.paper);

    List<String> buildPages(String assetPath, int pageCount) {
      final basePath = widget.paperMode == ExamPageMode.paper
          ? "papers/paper_1/exams/papers"
          : "papers/paper_1/exams/memos";
      return List.generate(
        pageCount,
        (index) => "$basePath/$assetPath/p${index + 1}.webp",
      );
    }

    void openPdf(ExamPaper document) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Container(
        // Explicitly forced layout heights prevent parental layout constraints from crushing the tile
        constraints: const BoxConstraints(minHeight: 72),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF673AB7).withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => openPdf(widget.paper),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF673AB7).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Color(0xFF673AB7),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.paper.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1B1F), // Standard dark onyx material text
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    iconSize: 22,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                      color: isSaved ? const Color(0xFFFFB300) : const Color(0xFF757575),
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSaved) {
                          widget.savedPapers.remove(widget.paper);
                        } else {
                          widget.savedPapers.add(widget.paper);
                        }
                      });
                      if (widget.onBookmarkToggle != null) {
                        widget.onBookmarkToggle!();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
