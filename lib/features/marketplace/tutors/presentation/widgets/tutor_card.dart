import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';

class TutorCard extends StatelessWidget {
  final TutorEntity tutor;
  final VoidCallback onTap;

  const TutorCard({
    super.key,
    required this.tutor,
    required this.onTap,
  });

  String _formatPrice(double cents) {
    return 'R${(cents / 100).toStringAsFixed(0)}/hr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColours.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColours.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Photo, Info, Verification Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColours.surfaceSecondary,
                          backgroundImage: tutor.photoUrl != null
                              ? NetworkImage(tutor.photoUrl!)
                              : null,
                          child: tutor.photoUrl == null
                              ? const Icon(Icons.person, color: AppColours.textSecondary)
                              : null,
                        ),
                        if (tutor.isVerified)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColours.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: AppColours.cobaltBlue,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tutor.displayName,
                            style: const TextStyle(
                              color: AppColours.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (tutor.headline != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              tutor.headline!,
                              style: const TextStyle(
                                color: AppColours.textSecondary,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: AppColours.warningAmber),
                              const SizedBox(width: 4),
                              Text(
                                '${tutor.rating.toStringAsFixed(1)} ',
                                style: const TextStyle(
                                  color: AppColours.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '(${tutor.reviewCount})',
                                style: const TextStyle(
                                  color: AppColours.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('•', style: TextStyle(color: AppColours.textMuted)),
                              const SizedBox(width: 8),
                              Text(
                                '${tutor.experienceYears} yrs exp',
                                style: const TextStyle(
                                  color: AppColours.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColours.border, height: 1),
                const SizedBox(height: 12),
                // Bottom Row: Teaching Modes & Price Pills
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: tutor.teachingModes.map((mode) {
                        final isOnline = mode == TeachingMode.online;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOnline
                                ? AppColours.cobaltBlue.withValues(alpha: 0.08)
                                : AppColours.electricViolet.withValues(alpha:0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isOnline
                                ? 'Online: ${_formatPrice(tutor.onlinePriceCents)}'
                                : 'In-Person: ${_formatPrice(tutor.inPersonPriceCents)}',
                            style: TextStyle(
                              color: isOnline ? AppColours.cobaltBlue : AppColours.electricViolet,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColours.textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
