import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/paper_1/data/exam_paper.dart';
import 'package:math_matric/routes/papers/resources/models/paper_item.dart';
import 'package:math_matric/routes/papers/resources/models/topic_item.dart';
import 'package:math_matric/routes/papers/resources/components/topic_list_tile.dart';
import 'package:math_matric/routes/papers/resources/components/section_type.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_memo_page.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_paper_page.dart';

class TopicsSliverList extends StatefulWidget {
  final ScrollController scrollController;
  final PaperItem content;
  final String listTopicTitle;
  const TopicsSliverList({
    super.key,
    required this.scrollController,
    required this.content,
    required this.listTopicTitle,
  });

  @override
  State<TopicsSliverList> createState() => _TopicsSliverListState();
}

class _TopicsSliverListState extends State<TopicsSliverList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<TopicItem> content;
  static const int _staggerMs = 100;

  @override
  void initState() {
    super.initState();

    final totalMs = (widget.content.topics.length + 1) * _staggerMs;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    // start the staggered entrance
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // returns an animation for a specific index inside [0..1]
  Animation<double> _itemInterval(int index) {
    final double start =
        (index * _staggerMs) / _controller.duration!.inMilliseconds;
    final double end =
        ((index * _staggerMs) + (_staggerMs + 150)) /
        _controller.duration!.inMilliseconds;
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        start.clamp(0.0, 1.0),
        end.clamp(0.0, 1.0),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 120,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(widget.listTopicTitle),
          ),
        ),

        SliverPadding(padding: const EdgeInsets.symmetric(vertical: 8)),

        // animated sliver list
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= widget.content.topics.length) return null;
            final item = widget.content.topics[index];
            final anim = _itemInterval(index);

            return AnimatedBuilder(
              animation: anim,
              builder: (context, child) {
                // slide from below and fade
                final double translateY = (1.0 - anim.value) * 18;
                final double opacity = anim.value;
                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, translateY),
                    child: child,
                  ),
                );
              },
              child: TopicListTile(
                item: item,
                onTap: () {
                  // keep this synchronous
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SectionType(
                        pageTitle: item.pageTitle,
                        tabTitles: item.tab.tabTitles,
                        tabPages: [
                          ExamPaperPage(pdfPath: ExamPaperRepository.papers.first, pdfTitle: ExamPaperRepository.papers.first,),
                          ExamMemoPage(pdfPath: '',),
                        ],
                        content: widget.content,
                      ),
                    ),
                  );
                },
              ),
            );
          }, childCount: widget.content.topics.length),
        ),

        SliverPadding(padding: const EdgeInsets.only(bottom: 96)),
      ],
    );
  }
}
