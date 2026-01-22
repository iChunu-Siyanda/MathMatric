import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/models/paper_item_modal.dart';
import 'package:math_matric/routes/papers/resources/components/main/topic_list_tile.dart';
import 'package:math_matric/routes/papers/resources/components/main/section_type.dart';
import 'package:math_matric/routes/papers/resources/models/section_context_modal.dart';

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
  static const int _staggerMs = 100;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: (widget.content.topics.length + 1) * _staggerMs),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _itemInterval(int index) {
    final start = (index * _staggerMs) / _controller.duration!.inMilliseconds;
    final end = ((index * _staggerMs) + (_staggerMs + 150)) /
        _controller.duration!.inMilliseconds;

    return CurvedAnimation(
      parent: _controller,
      curve:
          Interval(start.clamp(0, 1), end.clamp(0, 1), curve: Curves.easeOut),
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
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(widget.listTopicTitle),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = widget.content.topics[index];
              final anima = _itemInterval(index);

              return AnimatedBuilder(
                animation: anima,
                builder: (_, child) => Opacity(
                  opacity: anima.value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - anima.value) * 18),
                    child: child,
                  ),
                ),
                child: TopicListTile(
                  item: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SectionType(
                          pageTitle: item.pageTitle,
                          tabs: item.tab.tabs,
                          sectionContext: SectionContext(
                            paper: widget.content, 
                            topic: item, 
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            childCount: widget.content.topics.length,
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 96)),
      ],
    );
  }
}
