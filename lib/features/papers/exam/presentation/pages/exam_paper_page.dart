import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/shared/entities/section_context_modal.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_bloc.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_event.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_state.dart';
import 'package:math_matric/features/papers/exam/presentation/widgets/exam_tile.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ExamPaperPage extends StatefulWidget {
  final SectionContext contextData;
  final ExamPageMode mode;
  final String? paperId;

  const ExamPaperPage({
    super.key,
    required this.contextData,
    required this.mode,
    this.paperId,
  });

  @override
  State<ExamPaperPage> createState() => _ExamPaperPageState();
}

class _ExamPaperPageState extends State<ExamPaperPage> with SingleTickerProviderStateMixin {
  final Set<ExamPaper> savedPapers = {};
  late final AnimationController _controller;
  static const int _staggerMs = 100;
  bool get isPaper => widget.mode == ExamPageMode.paper;

  @override
  void initState() {
    super.initState();

    context.read<ExamBloc>().add(
      ExamPaperRequested(widget.contextData.paperType,
      widget.contextData.session!, widget.contextData.year),
    );

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800,)
      );

     _controller.forward();   
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
      slivers: [
        BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            if (state is ExamPaperLoading) {
              // Must return a sliver inside CustomScrollView
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is ExamPaperError) {
              return SliverFillRemaining(
                child: Center(child: Text(state.message)),
              );
            }

            if (state is ExamPaperListLoaded) {
              final filteredSections = state.sections.map((key, papers) {
                final filtered = papers
                    .where((p) => isPaper ? !p.isMemo : p.isMemo)
                    .toList();
                return MapEntry(key, filtered);
              });

              return SliverMainAxisGroup(
                slivers: filteredSections.entries
                    .where((entry) => entry.value.isNotEmpty)
                    .map((entry) => _section(entry.key, entry.value))
                    .toList(),
              );
            }

            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }

  Widget _section(String title, List<ExamPaper> papers) {
    return MultiSliver(
      children: [
        // Section Title with padding
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        // Scrollable List items
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final anima = _itemInterval(index);
        
              return AnimatedBuilder(
                animation: anima,
                builder: (_, child) => Opacity(
                  opacity: anima.value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - anima.value) * 18),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10), // Replaces vertical gap
                      child: child,
                    ),
                  ),
                ),
                child: ExamTile(
                  paper: papers[index],
                  savedPapers: savedPapers,
                  paperMode: widget.mode,
                  onBookmarkToggle: (){
                    setState(() {
                      //...
                    });
                  },
                ),
              );
            },
            childCount: papers.length,
          ),
        ),
      ],
    );
  }
}
