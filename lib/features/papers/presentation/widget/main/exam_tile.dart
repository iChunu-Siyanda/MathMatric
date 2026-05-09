import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';

class ExamTile extends StatelessWidget{
  final ExamPaper paper;
  const ExamTile({super.key, required this.paper});

  @override
  Widget build(BuildContext context) {
  final isSaved = _savedPapers.contains(paper);
  
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // Multi-layered gradient for realistic glass shine
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.04),
              ],
            ),
            // Micro-border to simulate glass thickness
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            // Soft glow instead of a harsh shadow
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openPdf(paper),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Premium Document Visual Anchor
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Paper Title Section
                    Expanded(
                      child: Text(
                        paper.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.95),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Action Button with Ripple Effect
                    IconButton(
                      iconSize: 22,
                      splashRadius: 22,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                          key: ValueKey<bool>(isSaved),
                          color: isSaved ? const Color(0xFFFFB300) : Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSaved ? _savedPapers.remove(paper) : _savedPapers.add(paper);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
};

}