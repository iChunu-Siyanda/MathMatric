import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/paper_badge.dart';
import 'package:math_matric/theme/app_colours.dart';

class PaperCard extends StatefulWidget {
  const PaperCard({
    super.key,
    required this.data,
    required this.title,
  });

  final PaperItem data;
  final String title;

  @override
  State<PaperCard> createState() => _PaperCardState();
}

class _PaperCardState extends State<PaperCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? AppColours.primaryAccent.withAlpha(40)
                  : Colors.black.withAlpha(18),
              blurRadius: _hovered ? 22 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/algebra.webp',
                  fit: BoxFit.cover,
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColours.cobaltBlue.withAlpha(25),
                        AppColours.textPrimary.withAlpha(210),
                      ],
                    ),
                  ),
                ),
              ),

              // Interactive Hover Border
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _hovered
                          ? AppColours.primaryAccent.withAlpha(150)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              // Card Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaperBadge(title: widget.title),

                    const Spacer(),

                    Text(
                      widget.data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColours.surface,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Soft hide brief on small square cards to avoid overflow
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxHeight < 120) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          widget.data.brief,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColours.surface.withAlpha(210),
                            fontSize: 11,
                            height: 1.3,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Text(
                          'Explore topics',
                          style: TextStyle(
                            color: AppColours.surface.withAlpha(220),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const Spacer(),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _hovered
                                ? AppColours.primaryAccent
                                : AppColours.surface.withAlpha(35),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: AppColours.surface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
