import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/presentation/widget/supporting/paper_card.dart';
import 'package:math_matric/features/papers/presentation/widget/supporting/streak_sliver.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/presentation/pages/topics_sliver_list.dart';
import 'package:math_matric/features/streak/domain/entities/streak_variant_modal.dart';

//data.topics
class PaperTile extends StatelessWidget {
  final SheetVariant variant;
  final StreakContent? streakData;
  final PaperItem data;
  final PaperType paperType;
  final Animation<double> animation;

  const PaperTile._(
      {super.key,
      required this.data,
      this.streakData,
      required this.paperType,
      required this.animation,
      required this.variant})
      : assert(
          variant != SheetVariant.streak || streakData != null,
          'streakData must be provided for SheetVariant.streak',
        );

  factory PaperTile.streak({
    required PaperItem data,
    required StreakContent streakData,
    required Animation<double> animation,
    required PaperType paperType,
    Key? key,
  }) {
    return PaperTile._(
      key: key,
      variant: SheetVariant.streak,
      data: data,
      streakData: streakData,
      animation: animation,
      paperType: paperType,
    );
  }

  factory PaperTile.topics({
    required PaperItem data,
    required Animation<double> animation,
    required PaperType paperType,
    Key? key,
  }) {
    return PaperTile._(
      key: key,
      variant: SheetVariant.topics,
      data: data,
      animation: animation,
      paperType: paperType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = Tween(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

    final slide = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

    return ScaleTransition(
      scale: scale,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: slide,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Allows full-screen height
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return FractionallySizedBox(
                    widthFactor: 0.95,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.90, // starts at 90% of screen height
                      maxChildSize: 0.95, // max height
                      minChildSize: 0.50,
                      expand: false,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: _buildSlivers(context, scrollController),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: PaperCard(data: data),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSlivers(
      BuildContext context, ScrollController scrollController) {
    switch (variant) {
      case SheetVariant.streak:
        return [
          _SheetGrabHandle(),
          StreakSliver(
            content: streakData!,
          ),
        ];

      case SheetVariant.topics:
        return [
          _SheetGrabHandle(),
          TopicsSliverList(
            content: data,
            scrollController: scrollController,
            listTopicTitle: data.section!.title,
            paperType: paperType, 
          ),
        ];
    }
  }
}

class _SheetGrabHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 5,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
