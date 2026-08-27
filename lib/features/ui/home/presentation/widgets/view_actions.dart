import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/home/domain/entities/last_studied.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_bloc.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_event.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class ViewActions {
  static void navigateToPaper(BuildContext context, LastStudied topic) {
    context.push(
      Routes.examPaperViewer,
      extra: {
        "title": topic.title,
        "pageAssets": topic.assets,
      },
    );
  }

  static void removeTopic(BuildContext context, String title) {
    context.read<StudyHistoryBloc>().add(RemoveTopicFromHistory(title));
  }

  static void showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Study History?'),
        content: const Text('This will remove all your recently practiced topics from local memory.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<StudyHistoryBloc>().add(ClearStudyHistory());
              Navigator.pop(dialogContext);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

}
