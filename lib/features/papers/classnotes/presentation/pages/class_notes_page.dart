import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/classnotes/presentation/bloc/class_notes_bloc.dart';
import 'package:math_matric/features/papers/classnotes/presentation/bloc/class_notes_state.dart';

class ClassNotesPage extends StatelessWidget {
  const ClassNotesPage({super.key});

  //How to trigger it:
  // For all class notes:
  // context.read<ClassNotesBloc>().add(
  //   const ClassNotesRequested(),
  // );

  // For a topic-specific page:
  // context.read<ClassNotesBloc>().add(
  //   ClassNotesByTopicRequested(
  //     topicId: topicId,
  //   ),
  // );

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