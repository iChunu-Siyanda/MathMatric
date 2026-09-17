import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/widgets/tutor_card.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class BuildTutorSliverList extends StatelessWidget {
  final List<TutorEntity> tutors;
  final bool isLoadingMore;
  final bool hasMore;

  const BuildTutorSliverList({
    super.key, 
    required this.tutors, 
    required this.isLoadingMore, 
    required this.hasMore, 
  });

  @override
  Widget build(BuildContext context) {
    if (tutors.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'No tutors available matching criteria.',
            style: TextStyle(color: AppColours.textSecondary),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= tutors.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(color: AppColours.cobaltBlue),
                ),
              );
            }

            final tutor = tutors[index];
            return TutorCard(
              tutor: tutor,
              onTap: () => context.go(Routes.tutorProfile, extra: tutor.id),
            );
          },
          childCount: tutors.length + (isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }
}

 
