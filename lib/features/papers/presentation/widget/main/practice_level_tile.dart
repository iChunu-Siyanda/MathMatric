import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';

class PracticeLevelTile extends StatefulWidget {
  final PracticeLevel level;
  final VoidCallback onTap;

  const PracticeLevelTile({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  State<PracticeLevelTile> createState() => _PracticeLevelTileState();
}

class _PracticeLevelTileState extends State<PracticeLevelTile> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    final scale = _pressed ? 0.97 : 1.0;

    final effectiveColor =
        level.isUnlocked ? Colors.grey : Colors.red;

    return Opacity(
      opacity: level.isUnlocked ? 0.6 : 1,
      child: GestureDetector(
        onTapDown: level.isUnlocked ? _onTapDown : null,
        onTapUp: level.isUnlocked
            ? null
            : (d) {
                _onTapUp(d);
                widget.onTap();
              },
        onTapCancel: level.isUnlocked ? _onCancel:null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Transform.scale(
            scale: scale,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ICON
                    Stack(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                effectiveColor.withValues(alpha: 0.9),
                                effectiveColor.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                          child: Icon(
                            level.isUnlocked
                                ? Icons.lock_open
                                : Icons.lock_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),

                        if (level.isCompleted)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // TITLE + SUBTITLE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            level.subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // XP BADGE
                    if (level.isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              effectiveColor.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          "+${level.xpReward} XP",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: effectiveColor,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // PROGRESS BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0,
                    minHeight: 6,
                    backgroundColor:
                        Colors.grey.withValues(alpha: 0.15),
                    valueColor:
                        AlwaysStoppedAnimation(effectiveColor),
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
