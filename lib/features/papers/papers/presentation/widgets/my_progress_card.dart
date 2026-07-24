import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/progress_summary.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/compact_progress_layout.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/view_buttn.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/wide_progress_layout.dart';
import 'package:math_matric/theme/app_colours.dart';

class MyProgressCard extends StatelessWidget {
  final ProgressSummary progress;
  final VoidCallback? onTap;

  const MyProgressCard({
    super.key,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 182, 222, 249),
            Color(0xFFEFF6FF),
            Color(0xFFF5F3FF),
          ],
        ),
        border: Border.all(
          color: AppColours.primaryAccent.withAlpha(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColours.primaryAccent.withAlpha(20),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'My Progress',
                style: TextStyle(
                  color: AppColours.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              if (onTap != null) ViewButton(onTap: onTap!),
            ],
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 520;

              if (isWide) {
                return WideProgressLayout(
                  progress: progress,
                );
              }

              return CompactProgressLayout(
                progress: progress,
              );
            },
          ),
        ],
      ),
    );
  }
}
