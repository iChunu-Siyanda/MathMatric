import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_paper.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/theme/app_colours.dart'; // Adjust import path if needed

class ExamTile extends StatefulWidget {
  final ExamPaper paper;
  final ExamPageMode paperMode;
  final Set<ExamPaper> savedPapers;
  final VoidCallback? onBookmarkToggle;

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
  List<String> _buildPagePaths(String assetPath, int pageCount) {
    final basePath = widget.paperMode == ExamPageMode.paper
        ? "papers/paper_1/exams/papers"
        : "papers/paper_1/exams/memos";

    return List.generate(
      pageCount,
      (index) => "$basePath/$assetPath/p${index + 1}.webp",
    );
  }

  void _openViewer(BuildContext context, ExamPaper document) {
    final pages = _buildPagePaths(document.assetPath, document.pageCount);

    context.push(
      Routes.examPaperViewer,
      extra: {
        'title': document.title,
        'pageAssets': pages,
      },
    );
  }

  void _toggleBookmark(bool isSaved) {
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
  }

  @override
  Widget build(BuildContext context) {
    final isSaved = widget.savedPapers.contains(widget.paper);
    final isMemo = widget.paperMode == ExamPageMode.memo ||
        widget.paper.title.toLowerCase().contains('memo');

    // Color accents based on paper vs memo
    final accentColor =
        isMemo ? AppColours.electricViolet : AppColours.cobaltBlue;
    final iconData =
        isMemo ? Icons.assignment_turned_in_outlined : Icons.description_outlined;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 76),
        decoration: BoxDecoration(
          color: AppColours.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColours.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColours.textPrimary.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            highlightColor: accentColor.withValues(alpha: 0.05),
            splashColor: accentColor.withValues(alpha: 0.08),
            onTap: () => _openViewer(context, widget.paper),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Icon Box with gradient tint accent
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      iconData,
                      color: accentColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & Metadata Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.paper.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColours.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            // Tag Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColours.surfaceSecondary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isMemo ? 'MEMO' : 'QUESTION PAPER',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColours.textSecondary,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.paper.pageCount} Pages',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColours.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Bookmark Button with active Amber state
                  Material(
                    color: isSaved
                        ? AppColours.warningAmber.withValues(alpha: 0.12)
                        : Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _toggleBookmark(isSaved),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: isSaved ? 1.1 : 1.0,
                          child: Icon(
                            isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            size: 22,
                            color: isSaved
                                ? AppColours.warningAmber
                                : AppColours.textMuted,
                          ),
                        ),
                      ),
                    ),
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
