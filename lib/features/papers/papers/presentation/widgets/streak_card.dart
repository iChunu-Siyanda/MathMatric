import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/action_card_button.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/mini_card_stat.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/streak_card_header.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/streak_card_number.dart';
import 'package:math_matric/theme/app_colours.dart';

class StreakCard extends StatelessWidget {
  final int current;
  final int best;
  final VoidCallback onTapStreak;

  const StreakCard({
    super.key,
    required this.current,
    required this.best,
    required this.onTapStreak,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasStreak = current > 0;
    final bool isPersonalBest = current > 0 && current >= best;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTapStreak,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE0F2FE),
                Color(0xFFEFF6FF),
                Color(0xFFF5F3FF),
              ],
            ),
            border: Border.all(
              color: AppColours.primaryAccent.withAlpha(45),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColours.primaryAccent.withAlpha(22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative ambient glow
              Positioned(
                top: -70,
                right: -45,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColours.cobaltBlue.withAlpha(20),
                  ),
                ),
              ),

              Positioned(
                bottom: -80,
                left: -60,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColours.secondaryAccent.withAlpha(14),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreakCardHeader(
                      current: current,
                      isPersonalBest: isPersonalBest,
                    ),

                    const SizedBox(height: 18),

                    StreakCardNumber(
                      current: current,
                      hasStreak: hasStreak,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MiniCardStat(
                          label: 'Best streak',
                          value: '$best days',
                        ),

                        const Spacer(),

                        ActionCardButton(
                          label: 'View streak',
                          onTap: onTapStreak,
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
