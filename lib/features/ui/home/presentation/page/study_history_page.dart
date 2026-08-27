import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_bloc.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_state.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/build_empty_state.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/build_grid_view.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/build_list_view.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/view_actions.dart';
// Replace with your actual model and bloc imports

class StudyHistoryPage extends StatefulWidget {
  const StudyHistoryPage({super.key});

  @override
  State<StudyHistoryPage> createState() => _StudyHistoryPageState();
}

class _StudyHistoryPageState extends State<StudyHistoryPage> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Toggle Grid / List layout
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            tooltip: _isGridView ? 'Switch to List View' : 'Switch to Grid View',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          // Clear All History Button
          BlocBuilder<StudyHistoryBloc, StudyHistoryState>(
            builder: (context, state) {
              if (state.recentTopics.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Clear All History',
                onPressed: () => ViewActions.showClearAllDialog(context),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<StudyHistoryBloc, StudyHistoryState>(
        builder: (context, state) {
          if (state.recentTopics.isEmpty) {
            return BuildEmptyState();
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isGridView
                ? BuildGridView(topics: state.recentTopics)
                : BuildListView(topics: state.recentTopics,),
          );
        },
      ),
    );
  }
}
