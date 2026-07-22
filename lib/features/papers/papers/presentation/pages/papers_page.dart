import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/domain/entities/progress_summary.dart';
import 'package:math_matric/features/papers/papers/presentation/bloc/papers_bloc.dart';
import 'package:math_matric/features/papers/papers/presentation/bloc/papers_event.dart';
import 'package:math_matric/features/papers/papers/presentation/bloc/papers_state.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/exam_grid.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/exam_section_header.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/my_progress_card.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/grid_insertion_controller.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/papers_header.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/study_modes_section.dart';
import 'package:math_matric/theme/app_colours.dart';

class PapersPage extends StatefulWidget {
  final PaperType paperType;
  const PapersPage({super.key, required this.paperType});

  @override
  State<PapersPage> createState() => _PapersPageState();
}

class _PapersPageState extends State<PapersPage> {
  final GlobalKey<SliverAnimatedGridState> _gridKey = GlobalKey();
  GridInsertionController? _insertionController;

  @override
  void initState() {
    super.initState();
    context.read<PapersBloc>().add(LoadPaperRequested(widget.paperType));
  }

  void _runGridAnimation(int itemCount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _insertionController = GridInsertionController(
        gridState: _gridKey.currentState!,
        totalItems: itemCount,
      );
      _insertionController!.staggerInsert();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: BlocBuilder<PapersBloc, PapersState>(
        builder: (context, state) {
          if (state is PapersLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColours.primaryAccent,
              ),
            );
          }

          if (state is PapersLoaded) {
            final items = state.paper;

            _runGridAnimation(items.length);

            return CustomScrollView(
              slivers: [
                PapersHeader(
                  paperType: widget.paperType,
                ),

                SliverToBoxAdapter(
                  child: MyProgressCard(
                    progress: ProgressSummary(
                      completedTopics: 0,
                      totalTopics: 0,
                      currentStreak: 0,
                      bestStreak: 0,
                    ),
                  ),
                ),

                const StudyModesSection(),

                const ExamSectionHeader(),

                ExamGrid(
                  items: items,
                  gridKey: _gridKey,
                  paperType: widget.paperType,
                ),
              ],
            );
          }

          if (state is PapersError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: AppColours.errorRed,
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
