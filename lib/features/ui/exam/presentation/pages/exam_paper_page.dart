import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/ui/papers/domain/entities/paper_type.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/entities/section_context_modal.dart';
import 'package:math_matric/features/ui/exam/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/ui/exam/presentation/bloc/exam_bloc.dart';
import 'package:math_matric/features/ui/exam/presentation/bloc/exam_event.dart';
import 'package:math_matric/features/ui/exam/presentation/bloc/exam_state.dart';
import 'package:math_matric/features/ui/exam/presentation/widgets/exam_tile.dart';
import 'package:math_matric/core/theme/app_colours.dart';
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
  final Set<ExamPaperEntity> savedPapers = {};
  late final AnimationController _controller;
  static const int _staggerMs = 100;
  bool get isPaper => widget.mode == ExamPageMode.paper;

  @override
  void initState() {
    super.initState();

    final sessionName = widget.contextData.paper.section?.title ?? 
                      widget.contextData.topic.pageTitle;
    final paperType = widget.contextData.paperType == PaperType.paper1 ? 'Paper1' : 'Paper2';

    context.read<ExamBloc>().add(
      ExamPapersRequested(
        subjectId: widget.contextData.topic.topicId ?? 'mathematics_grade12', 
        paperType: paperType, 
        session: sessionName,
        year: widget.contextData.year, 
      ),
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
    return BlocListener<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamPaperPagesLoaded) {
          debugPrint('--> LOADED PAGES: ${state.pages}');
          // Check if paths exist on physical device disk
          for (final path in state.pages) {
            debugPrint('--> File exists ($path): ${File(path).existsSync()}');
          }
          context.push(
            Routes.examPaperViewer,
            extra: {
              'title': state.paper.title,
              'pageAssets': state.pages,
            },
          );
        }

        if (state is ExamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          BlocBuilder<ExamBloc, ExamState>(
            builder: (context, state) {
              if (state is ExamLoading) {
                // Must return a sliver inside CustomScrollView
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
      
              if (state is ExamError) {
                return SliverFillRemaining(
                  child: Center(child: Text(state.message)),
                );
              }
      
              if (state is ExamPaperListLoaded) {
                debugPrint("DEBUG: Total papers fetched from BLoC: ${state.papers.length}");
                for (var p in state.papers) {
                  debugPrint("DEBUG: Paper ID: ${p.id} | isMemo: ${p.isMemo} | isNational: ${p.isNational}");
                }

                final papers = state.papers
                    .where((p) => isPaper ? !p.isMemo : p.isMemo)
                    .toList();

                debugPrint("DEBUG: Filtered papers for mode ($widget.mode): ${papers.length}");  
                if (papers.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text("No papers found for this criteria."),
                    ),
                  );
                }
      
                final national = papers
                    .where((p) => p.isNational)
                    .toList();
      
                final provincial = papers
                    .where((p) => !p.isNational)
                    .toList();
      
                return SliverMainAxisGroup(
                  slivers: [
                    if (national.isNotEmpty)
                      _section('National', national),
      
                    if (provincial.isNotEmpty)
                      _section('Provincial', provincial),
                  ],
                );
              }
      
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<ExamPaperEntity> papers) {
    return MultiSliver(
      children: [
        // Section Header Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 8,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
                color: AppColours.textPrimary,
              ),
            ),
          ),
        ),
        // Scrollable Animated List Items
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
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
                        padding: const EdgeInsets.only(bottom: 12),
                        child: child,
                      ),
                    ),
                  ),
                  child: ExamTile(
                    paper: papers[index],
                    savedPapers: savedPapers,
                    paperMode: widget.mode,
                    onBookmarkToggle: () {
                      setState(() {
                        // ... bookmark logic ...
                      });
                    },
                  ),
                );
              },
              childCount: papers.length,
            ),
          ),
        ),
      ],
    );
  }
}
