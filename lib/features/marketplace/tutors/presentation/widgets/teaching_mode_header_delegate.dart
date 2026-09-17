import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_event.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_state.dart';

class TeachingModeHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColours.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: BlocBuilder<TutorSearchBloc, TutorSearchState>(
        builder: (context, state) {
          final selectedMode = state is TutorSearchLoaded ? state.teachingMode : null;

          return Row(
            children: [
              _buildFilterChip(
                context: context,
                label: 'All Modes',
                isSelected: selectedMode == null,
                onTap: () {
                  context.read<TutorSearchBloc>().add(const TeachingModeFilterChanged(null),);
                },
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context: context,
                label: 'Online',
                isSelected: selectedMode == TeachingMode.online,
                onTap: () {
                  context.read<TutorSearchBloc>().add(const TeachingModeFilterChanged(TeachingMode.online),);
                },
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context: context,
                label: 'In-Person',
                isSelected: selectedMode == TeachingMode.inPerson,
                onTap: () {
                  context.read<TutorSearchBloc>().add(
                        const TeachingModeFilterChanged(TeachingMode.inPerson),
                      );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColours.cobaltBlue : AppColours.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColours.cobaltBlue : AppColours.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColours.surface : AppColours.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50.0;
  @override
  double get minExtent => 50.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
