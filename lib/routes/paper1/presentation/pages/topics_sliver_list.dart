// features/paper1/presentation/pages/topics_sliver_list.dart
import 'package:flutter/material.dart';
import 'package:math_matric/routes/paper1/data/topic_item.dart';
import 'package:math_matric/routes/paper1/presentation/components/topic_list_tile.dart';

class TopicsSliverList extends StatefulWidget {
  final ScrollController scrollController;
  const TopicsSliverList({super.key, required this.scrollController});

  @override
  State<TopicsSliverList> createState() => _TopicsSliverListState();
}

class _TopicsSliverListState extends State<TopicsSliverList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<TopicItem> _items;
  static const int _staggerMs = 100;

  @override
  void initState() {
    super.initState();

    // sample topics — replace with your real data or load from model
    _items = const [
      TopicItem(title: 'Algebra', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF6A6CE5), icon: Icons.calculate),
      TopicItem(title: 'Geometry', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF00BFA6), icon: Icons.straighten),
      TopicItem(title: 'Trigonometry', subtitle: 'Grade 12 · Paper 1', color: Color(0xFFFF7A59), icon: Icons.show_chart),
      TopicItem(title: 'Calculus', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF3A7BD5), icon: Icons.functions),
      TopicItem(title: 'Functions', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF9C27B0), icon: Icons.timeline),
      TopicItem(title: 'Graphs', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF00C2FF), icon: Icons.grid_on),
    ];

    final totalMs = (_items.length + 1) * _staggerMs;
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
    final double start = (index * _staggerMs) / _controller.duration!.inMilliseconds;
    final double end = ((index * _staggerMs) + (_staggerMs + 150)) / _controller.duration!.inMilliseconds;
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut),
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
          flexibleSpace: const FlexibleSpaceBar(title: Text('Paper 1 — Topics')),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),

        // animated sliver list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= _items.length) return null;
              final item = _items[index];
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
                    // Please keep this synchronous and create new route here:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TopicDetailPlaceholderPage(topic: item)),
                    );
                  },
                ),
              );
            },
            childCount: _items.length,
          ),
        ),

        // bottom padding so fab (if any) doesn't obscure list
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 96),
        ),
      ],
    );
  }
}

// simple placeholder page you can replace with your real detail page
class TopicDetailPlaceholderPage extends StatelessWidget {
  final TopicItem topic;
  const TopicDetailPlaceholderPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: Center(child: Text('Open ${topic.title} - implement this page')),
    );
  }
}
