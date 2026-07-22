import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/study_mode.dart';
import 'package:math_matric/theme/app_colours.dart';


class StudyModeCard extends StatefulWidget {
  final StudyMode mode;
  final VoidCallback onTap;

  const StudyModeCard({
    super.key,
    required this.mode,
    required this.onTap,
  });

  @override
  State<StudyModeCard> createState() => _StudyModeCardState();
}

class _StudyModeCardState extends State<StudyModeCard> {
  bool _hovered = false;

  bool get isPractice => widget.mode == StudyMode.practice;

  String get title => isPractice ? 'Practice' : 'Classnotes';

  String get description => isPractice
      ? 'Test yourself with topic-based questions.'
      : 'Review concepts and strengthen your understanding.';

  IconData get icon => isPractice
      ? Icons.psychology_rounded
      : Icons.menu_book_rounded;

  Color get accentColor => isPractice
      ? AppColours.primaryAccent
      : AppColours.secondaryAccent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: AppColours.surface,
          border: Border.all(
            color: _hovered
                ? accentColor.withAlpha(100)
                : AppColours.border,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? accentColor.withAlpha(28)
                  : Colors.black.withAlpha(10),
              blurRadius: _hovered ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: accentColor,
                      size: 23,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColours.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColours.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Text(
                        isPractice ? 'Start practising' : 'Open notes',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const Spacer(),

                      Icon(
                        Icons.arrow_forward_rounded,
                        color: accentColor,
                        size: 17,
                      ),
                    ],
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
