import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';

class QuizNextBtn extends StatelessWidget {
  const QuizNextBtn({
    super.key,
    required this.isOptionSelected,
    required this.isLastQuestion,
  });

  final bool isOptionSelected;
  final bool isLastQuestion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isOptionSelected
            ? () => context.read<QuizBloc>().add(SubmitAnswerEvent())
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: isOptionSelected ? 3 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isLastQuestion ? "Finish Quiz" : "Next Question",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isOptionSelected ? Colors.white : Colors.black26,
          ),
        ),
      ),
    );
  }
}
