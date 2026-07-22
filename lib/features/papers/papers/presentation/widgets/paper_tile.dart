import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/paper_card.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/papers/presentation/pages/topics_sliver_list.dart';
import 'package:math_matric/theme/app_colours.dart';

class PaperTile extends StatelessWidget {
  final PaperItem data;
  final PaperType paperType;
  final Animation<double> animation;

  const PaperTile({
    super.key, 
    required this.data, 
    required this.paperType, 
    required this.animation,
  });

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
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                barrierColor: AppColours.textPrimary.withAlpha(90),
                builder: (context) {
                  return FractionallySizedBox(
                    widthFactor: 0.98,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.90,
                      minChildSize: 0.50,
                      maxChildSize: 0.96,
                      expand: false,
                      snap: true,
                      snapSizes: const [
                        0.50,
                        0.90,
                        0.96,
                      ],
                      builder: (
                        context,
                        scrollController,
                      ) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: AppColours.background,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            child: CustomScrollView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                TopicsSliverList(
                                  content: data,
                                  scrollController: scrollController,
                                  listTopicTitle: data.section!.title,
                                  paperType: paperType, 
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: PaperCard(data: data, title: data.title,),
          ),
        ),
      ),
    );
  }
}
