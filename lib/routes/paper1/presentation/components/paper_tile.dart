import 'package:flutter/material.dart';
import 'package:math_matric/routes/paper1/data/paper_item.dart';
import 'package:math_matric/routes/paper1/presentation/pages/topics_sliver_list.dart';

class PaperTile extends StatelessWidget {
  final PaperItem data;
  final Animation<double> animation;

  const PaperTile({super.key, required this.data, required this.animation});

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
                  return DraggableScrollableSheet(
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
                        child: TopicsSliverList(
                          scrollController: scrollController,
                        ),
                      );
                    },
                  );
                },
              );
            },

            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PAPER 1',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        data.brief,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
