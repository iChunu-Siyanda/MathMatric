import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_state.dart';
import 'package:math_matric/features/papers/presentation/widget/main/paper_tile.dart';
import 'package:math_matric/features/papers/presentation/widget/main/grid_insertion_controller.dart';
import 'package:math_matric/features/streak/data/local/streak_data.dart';

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
    // Tell Bloc to load the correct paper
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
      body: BlocBuilder<PapersBloc, PapersState>(
        builder: (context, state) {
          if (state is PapersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PapersLoaded) {
            final items = state.paper;

            _runGridAnimation(items.length);

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 140,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      widget.paperType == PaperType.paper1
                          ? 'Paper 1'
                          : 'Paper 2',
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                SliverAnimatedGrid(
                  key: _gridKey,
                  initialItemCount: 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index, animation) {
                    if (index == 0) {
                      return PaperTile.streak(
                        streakData: StreakData.streakData,
                        animation: animation,
                        data: items.first,
                        paperType: widget.paperType,
                      );
                    }

                    final data = items[index];

                    return PaperTile.topics(
                      data: data,
                      animation: animation,
                      paperType: widget.paperType,
                    );
                  },
                ),
              ],
            );
          }

          if (state is PapersError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
