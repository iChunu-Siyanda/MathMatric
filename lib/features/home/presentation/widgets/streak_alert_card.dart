import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class StreakAlertCard extends StatefulWidget {
  const StreakAlertCard({
    super.key,
    required this.userName,
    required this.currentStreak,
    required this.personalBest,
    required this.onTap,
    this.onMilestoneTap,
  });

  final String userName;
  final int currentStreak;
  final int personalBest;

  final VoidCallback? onTap;
  final VoidCallback? onMilestoneTap;

  @override
  State<StreakAlertCard> createState() => _StreakAlertCardState();
}

class _StreakAlertCardState extends State<StreakAlertCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final milestone = _nextMilestone(widget.currentStreak);
    final previousMilestone = _previousMilestone(widget.currentStreak);

    final daysToMilestone =
        milestone - widget.currentStreak;

    final milestoneRange =
        milestone - previousMilestone;

    final progressInMilestone =
        widget.currentStreak - previousMilestone;

    final milestoneProgress =
        (progressInMilestone / milestoneRange)
            .clamp(0.0, 1.0);

    final message = _streakMessage(
      widget.currentStreak,
    );

    final personalBestMessage =
        _personalBestMessage(
      widget.currentStreak,
      widget.personalBest,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },

      child: GestureDetector(
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),

          curve: Curves.easeOutCubic,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: AppColours.surface,

            borderRadius: BorderRadius.circular(24),

            border: Border.all(
              color: _hovered
                  ? AppColours.neonCoral
                      .withValues(alpha: 0.45)
                  : AppColours.border
                      .withValues(alpha: 0.7),

              width: 1.5,
            ),

            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColours.neonCoral
                        .withValues(alpha: 0.12)
                    : Colors.black
                        .withValues(alpha: 0.04),

                blurRadius: _hovered
                    ? 24
                    : 12,

                offset: Offset(
                  0,
                  _hovered ? 9 : 4,
                ),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // =============================================================
              // HEADER
              // =============================================================

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'YOUR MOMENTUM',
                          style: TextStyle(
                            color:
                                AppColours.textMuted,

                            fontSize: 10,

                            fontWeight:
                                FontWeight.w800,

                            letterSpacing: 1.1,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          '${widget.userName}, $message',
                          maxLines: 2,

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            color:
                                AppColours.textPrimary,

                            fontSize: 19,

                            height: 1.15,

                            fontWeight:
                                FontWeight.w900,

                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          '${widget.currentStreak} consecutive '
                          '${widget.currentStreak == 1 ? 'day' : 'days'} '
                          'of learning.',
                          style: const TextStyle(
                            color:
                                AppColours.textSecondary,

                            fontSize: 13,

                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  // =========================================================
                  // STREAK BADGE
                  // =========================================================

                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 220,
                    ),

                    width: 48,
                    height: 48,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin:
                            Alignment.topLeft,

                        end:
                            Alignment.bottomRight,

                        colors: [
                          AppColours.neonCoral
                              .withValues(
                            alpha: _hovered
                                ? 0.22
                                : 0.13,
                          ),

                          AppColours.neonCoral
                              .withValues(
                            alpha: _hovered
                                ? 0.08
                                : 0.04,
                          ),
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: const Icon(
                      Icons.local_fire_department_rounded,

                      color:
                          AppColours.neonCoral,

                      size: 27,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              // =============================================================
              // STREAK JOURNEY
              // =============================================================

              _StreakJourney(
                currentStreak:
                    widget.currentStreak,

                previousMilestone:
                    previousMilestone,

                nextMilestone:
                    milestone,
              ),

              const SizedBox(
                height: 22,
              ),

              // =============================================================
              // NEXT MILESTONE
              // =============================================================

              _MilestonePanel(
                nextMilestone:
                    milestone,

                daysRemaining:
                    daysToMilestone,

                progress:
                    milestoneProgress,

                onTap:
                    widget.onMilestoneTap,
              ),

              const SizedBox(
                height: 16,
              ),

              // =============================================================
              // PERSONAL BEST CONTEXT
              // =============================================================

              _PersonalBestMessage(
                message:
                    personalBestMessage,
              ),

              const SizedBox(
                height: 20,
              ),

              // =============================================================
              // ACTION FOOTER
              // =============================================================

              Row(
                children: [
                  Text(
                    'Continue your journey',

                    style: TextStyle(
                      color: _hovered
                          ? AppColours.neonCoral
                          : AppColours.textPrimary,

                      fontSize: 13,

                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const Spacer(),

                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 220,
                    ),

                    curve:
                        Curves.easeOutCubic,

                    transform:
                        Matrix4.translationValues(
                      _hovered ? 5 : 0,
                      0,
                      0,
                    ),

                    child: Icon(
                      Icons.arrow_forward_rounded,

                      size: 18,

                      color: _hovered
                          ? AppColours.neonCoral
                          : AppColours.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// STREAK JOURNEY
// =============================================================================

class _StreakJourney extends StatelessWidget {
  const _StreakJourney({
    required this.currentStreak,
    required this.previousMilestone,
    required this.nextMilestone,
  });

  final int currentStreak;
  final int previousMilestone;
  final int nextMilestone;

  @override
  Widget build(BuildContext context) {
    final journeyDays =
        _journeyDays(
      currentStreak,
      previousMilestone,
      nextMilestone,
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            const Text(
              'YOUR JOURNEY',
              style: TextStyle(
                color:
                    AppColours.textMuted,

                fontSize: 10,

                fontWeight:
                    FontWeight.w800,

                letterSpacing: 1.0,
              ),
            ),

            const Spacer(),

            Text(
              '$currentStreak / $nextMilestone days',

              style: const TextStyle(
                color:
                    AppColours.textSecondary,

                fontSize: 11,

                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 14,
        ),

        SizedBox(
          height: 74,

          child: LayoutBuilder(
            builder:
                (
                  context,
                  constraints,
                ) {
                  return Stack(
                    children: [
                      // =====================================================
                      // CONNECTING PATH
                      // =====================================================

                      Positioned(
                        left: 10,
                        right: 10,
                        top: 22,

                        child: Row(
                          children: List.generate(
                            journeyDays.length - 1,

                            (index) {
                              //final currentDay = journeyDays[index];

                              final nextDay = journeyDays[index + 1];

                              final completed = nextDay <= currentStreak;

                              final isMilestoneSegment = nextDay == nextMilestone;

                              return Expanded(
                                child: Container(
                                  height: 3,

                                  margin:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 2,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    gradient:
                                        completed
                                            ? AppColours
                                                .mathMatricGradient
                                            : null,

                                    color: completed
                                        ? null
                                        : AppColours
                                            .border,

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      10,
                                    ),

                                    boxShadow:
                                        isMilestoneSegment
                                            ? [
                                                BoxShadow(
                                                  color: AppColours
                                                      .electricViolet
                                                      .withValues(
                                                    alpha:
                                                        0.18,
                                                  ),

                                                  blurRadius:
                                                      8,
                                                ),
                                              ]
                                            : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // =====================================================
                      // JOURNEY NODES
                      // =====================================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children:
                            journeyDays.map(
                          (day) {
                            final completed =
                                day <=
                                    currentStreak;

                            final isCurrent =
                                day ==
                                    currentStreak;

                            final isMilestone =
                                day ==
                                    nextMilestone;

                            return _JourneyNode(
                              day:
                                  day,

                              completed:
                                  completed,

                              isCurrent:
                                  isCurrent,

                              isMilestone:
                                  isMilestone,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  );
                },
          ),
        ),
      ],
    );
  }

  List<int> _journeyDays(
    int currentStreak,
    int previousMilestone,
    int nextMilestone,
  ) {
    final range =
        nextMilestone - previousMilestone;

    // For short milestones such as 7 → 10,
    // show every day.
    if (range <= 7) {
      return List.generate(
        range + 1,
        (index) =>
            previousMilestone + index,
      );
    }

    // For larger milestones, show a
    // compressed journey.
    final days = [
      previousMilestone,
      previousMilestone + 1,
      previousMilestone + 2,
      currentStreak,
      nextMilestone - 2,
      nextMilestone - 1,
      nextMilestone,
    ];

    return days
        .where((day) => day >= previousMilestone)
        .where((day) => day <= nextMilestone)
        .toSet()
        .toList()
      ..sort();
  }
}

// =============================================================================
// JOURNEY NODE
// =============================================================================

class _JourneyNode extends StatelessWidget {
  const _JourneyNode({
    required this.day,
    required this.completed,
    required this.isCurrent,
    required this.isMilestone,
  });

  final int day;
  final bool completed;
  final bool isCurrent;
  final bool isMilestone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(
            milliseconds: 250,
          ),

          curve:
              Curves.easeOutCubic,

          width: isCurrent
              ? 22
              : isMilestone
                  ? 18
                  : 14,

          height: isCurrent
              ? 22
              : isMilestone
                  ? 18
                  : 14,

          decoration: BoxDecoration(
            shape:
                BoxShape.circle,

            gradient: completed
                ? AppColours
                    .mathMatricGradient
                : null,

            color: completed
                ? null
                : isMilestone
                    ? AppColours
                        .surfaceSecondary
                    : AppColours
                        .surfaceSecondary,

            border: !completed
                ? Border.all(
                    color: isMilestone
                        ? AppColours
                            .electricViolet
                        : AppColours
                            .border,

                    width:
                        isMilestone
                            ? 2
                            : 1.5,
                  )
                : null,

            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: AppColours
                          .neonCoral
                          .withValues(
                        alpha: 0.35,
                      ),

                      blurRadius: 14,

                      spreadRadius: 2,
                    ),
                  ]
                : isMilestone
                    ? [
                        BoxShadow(
                          color: AppColours
                              .electricViolet
                              .withValues(
                            alpha: 0.18,
                          ),

                          blurRadius: 10,
                        ),
                      ]
                    : null,
          ),

          child: isCurrent
              ? const Icon(
                  Icons.local_fire_department_rounded,

                  color:
                      Colors.white,

                  size: 13,
                )
              : isMilestone
                  ? const Icon(
                      Icons.card_giftcard_rounded,

                      color:
                          AppColours
                              .electricViolet,

                      size: 11,
                    )
                  : null,
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          '$day',

          style: TextStyle(
            color: completed
                ? AppColours
                    .textPrimary
                : AppColours
                    .textMuted,

            fontSize: 10,

            fontWeight: completed ||
                    isMilestone
                ? FontWeight.w800
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// MILESTONE PANEL
// =============================================================================

class _MilestonePanel extends StatelessWidget {
  const _MilestonePanel({
    required this.nextMilestone,
    required this.daysRemaining,
    required this.progress,
    required this.onTap,
  });

  final int nextMilestone;
  final int daysRemaining;
  final double progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding:
            const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: AppColours
              .surfaceElevated,

          borderRadius:
              BorderRadius.circular(
            17,
          ),

          border: Border.all(
            color: AppColours
                .border
                .withValues(
              alpha: 0.7,
            ),
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,

                  decoration:
                      BoxDecoration(
                    color: AppColours
                        .electricViolet
                        .withValues(
                      alpha: 0.10,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      11,
                    ),
                  ),

                  child: const Icon(
                    Icons.card_giftcard_rounded,

                    color:
                        AppColours
                            .electricViolet,

                    size: 18,
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const Text(
                        'NEXT MILESTONE',

                        style: TextStyle(
                          color:
                              AppColours
                                  .textMuted,

                          fontSize: 9,

                          fontWeight:
                              FontWeight.w800,

                          letterSpacing:
                              0.9,
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      Text(
                        '$nextMilestone-day milestone',

                        style:
                            const TextStyle(
                          color:
                              AppColours
                                  .textPrimary,

                          fontSize: 14,

                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  daysRemaining == 1
                      ? '1 day left'
                      : '$daysRemaining days left',

                  style:
                      const TextStyle(
                    color:
                        AppColours
                            .electricViolet,

                    fontSize: 11,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                20,
              ),

              child:
                  LinearProgressIndicator(
                value:
                    progress,

                minHeight:
                    7,

                backgroundColor:
                    AppColours
                        .border,

                valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(
                  AppColours
                      .electricViolet,
                ),
              ),
            ),

            const SizedBox(
              height: 9,
            ),

            Text(
              'Keep showing up to unlock your next reward.',

              style:
                  const TextStyle(
                color:
                    AppColours
                        .textSecondary,

                fontSize: 11,

                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PERSONAL BEST MESSAGE
// =============================================================================

class _PersonalBestMessage extends StatelessWidget {
  const _PersonalBestMessage({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.workspace_premium_rounded,

          size: 16,

          color:
              AppColours
                  .warningAmber,
        ),

        const SizedBox(
          width: 7,
        ),

        Expanded(
          child: Text(
            message,

            maxLines: 1,

            overflow:
                TextOverflow.ellipsis,

            style:
                const TextStyle(
              color:
                  AppColours
                      .textSecondary,

              fontSize: 12,

              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// EMOTIONAL MESSAGES
// =============================================================================

String _streakMessage(
  int streak,
) {
  if (streak <= 0) {
    return 'let’s start something new.';
  }

  if (streak == 1) {
    return 'good start.';
  }

  if (streak <= 3) {
    return 'you’re building momentum.';
  }

  if (streak <= 6) {
    return 'you’re finding your rhythm.';
  }

  if (streak <= 13) {
    return 'you’re on a roll.';
  }

  if (streak <= 20) {
    return 'this is becoming a habit.';
  }

  if (streak <= 29) {
    return 'your consistency is impressive.';
  }

  return 'you’ve built something powerful.';
}

// =============================================================================
// PERSONAL BEST CONTEXT
// =============================================================================

String _personalBestMessage(
  int currentStreak,
  int personalBest,
) {
  if (currentStreak > personalBest) {
    return 'New personal best. You’re rewriting your record.';
  }

  if (currentStreak == personalBest) {
    return 'You’ve matched your personal best. Keep going.';
  }

  final difference =
      personalBest - currentStreak;

  if (difference == 1) {
    return 'One more day to match your personal best.';
  }

  return '$difference days to match your personal best.';
}

// =============================================================================
// MILESTONE SYSTEM
// =============================================================================

int _nextMilestone(
  int streak,
) {
  const milestones = [
    3,
    7,
    10,
    14,
    21,
    30,
    45,
    60,
    90,
    120,
    180,
    365,
  ];

  for (final milestone in milestones) {
    if (streak < milestone) {
      return milestone;
    }
  }

  // After 365 days, continue
  // with yearly milestones.
  return ((streak ~/ 365) + 1) * 365;
}

int _previousMilestone(
  int streak,
) {
  const milestones = [
    0,
    3,
    7,
    10,
    14,
    21,
    30,
    45,
    60,
    90,
    120,
    180,
    365,
  ];

  int previous = 0;

  for (final milestone in milestones) {
    if (milestone <= streak) {
      previous = milestone;
    } else {
      break;
    }
  }

  return previous;
}
