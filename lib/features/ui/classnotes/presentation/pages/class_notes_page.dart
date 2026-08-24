import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/progress/studysession/bloc/study_session_bloc.dart';
import 'package:math_matric/features/progress/studysession/bloc/study_session_event.dart';
import 'package:math_matric/features/ui/classnotes/presentation/bloc/class_notes_bloc.dart';
import 'package:math_matric/features/ui/classnotes/presentation/bloc/class_notes_state.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

class ClassNotesPage extends StatefulWidget {
  final String topicId;
  const ClassNotesPage({
    super.key,
    required this.topicId,
  });

  @override
  State<ClassNotesPage> createState() => _ClassNotesPageState();
}

class _ClassNotesPageState extends State<ClassNotesPage> {
  late final StudySessionBloc _studySessionBloc;

  @override
  void initState() {
    super.initState();

    _studySessionBloc = context.read<StudySessionBloc>();

    _studySessionBloc.add(
      StudySessionStarted(
        topicId: widget.topicId,
        activity: StudyActivity.notes,
      ),
    );
  }

  @override
  void dispose() {
    _studySessionBloc.add(
      const StudySessionCompleted(),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassNotesBloc, ClassNotesState>(
      builder: (context, state) {
        if (state is ClassNotesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ClassNotesError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is ClassNotesLoaded) {
          if (state.notes.isEmpty) {
            return const Center(
              child: Text('No class notes available.'),
            );
          }

          return ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];

              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}