import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/papers/data/model/tile_topics_p1_data.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_session.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/domain/entities/section_type_arguments.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/topic_list_tile.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/entities/section_context_modal.dart';
import 'package:math_matric/theme/app_colours.dart';

class TopicsSliverList extends StatefulWidget {
  final ScrollController scrollController;
  final PaperItem content;
  final String listTopicTitle;
  final PaperType paperType;

  const TopicsSliverList({
    super.key,
    required this.scrollController,
    required this.content,
    required this.listTopicTitle,
    required this.paperType,
  });

  @override
  State<TopicsSliverList> createState() => _TopicsSliverListState();
}

class _TopicsSliverListState extends State<TopicsSliverList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const int _staggerMs = 80;
  static const int _maxStaggeredItems = 8; // Prevent long animation delays

  @override
  void initState() {
    super.initState();
    final itemLength = widget.content.section?.topics.length ?? 0;
    // Cap stagger count so total animation duration stays under ~800ms
    final animatedCount = math.min(itemLength, _maxStaggeredItems);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (animatedCount + 1) * _staggerMs + 200),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _itemInterval(int index) {
    // Cap index calculation so items beyond threshold appear immediately with the last group
    final cappedIndex = math.min(index, _maxStaggeredItems);
    final totalMs = _controller.duration!.inMilliseconds;

    final start = (cappedIndex * _staggerMs) / totalMs;
    final end = ((cappedIndex * _staggerMs) + 200) / totalMs;

    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topics = widget.content.section?.topics ?? [];

    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColours.background,

          // Remove Flutter's automatic back arrow.
          automaticallyImplyLeading: false,

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 22,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColours.surface.withAlpha(210),
                  foregroundColor: AppColours.textSecondary,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(9),
                ),
              ),
            ),
          ],

          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,

            titlePadding: const EdgeInsetsDirectional.only(
              start: 20,
              bottom: 16,
              end: 70,
            ),

            title: Text(
              widget.listTopicTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColours.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),

            background: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColours.softHeaderGradient,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.only(top: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = topics[index];
                final animation = _itemInterval(index);

                final years = TileTopicsP1Data.years;
                final year = years[index % years.length];

                final session = ExamSession.tryParse(
                  item.pageTitle?.toString(),
                );

                return AnimatedBuilder(
                  animation: animation,
                  builder: (_, child) {
                    final value = Curves.easeOutCubic.transform(
                      animation.value,
                    );

                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          (1 - value) * 18,
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: TopicListTile(
                    item: item,
                    onTap: () {
                      debugPrint(
                        'TopicListTile - topicId: ${item.topicId}',
                      );

                      context.push(
                        Routes.sectionPage,
                        extra: SectionTypeArguments(
                          pageTitle: item.pageTitle,
                          tabs: item.tab.tabs,
                          topicId: item.topicId,
                          sectionContext: SectionContext(
                            paper: widget.content,
                            session: session,
                            topic: item,
                            paperType: widget.paperType,
                            year: year,
                          ),
                          tabType: item.tab.tabType,
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: topics.length,
            ),
          ),
        ),

        const SliverPadding(
          padding: EdgeInsets.only(bottom: 96),
        ),
      ],
    );
  }
}
