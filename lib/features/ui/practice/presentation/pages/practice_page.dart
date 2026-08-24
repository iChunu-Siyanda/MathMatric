import 'package:flutter/material.dart';
import 'package:math_matric/features/progress/studysession/bloc/study_session_bloc.dart';
import 'package:math_matric/features/progress/studysession/bloc/study_session_event.dart';
import 'package:math_matric/features/ui/practice/presentation/widgets/practice_card.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

class PracticePage extends StatefulWidget {
  final String topicId;
  const PracticePage({super.key, required this.topicId});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late StudySessionBloc _sessionBloc;

  @override
  void initState(){
    super.initState();

    _sessionBloc.add(
      StudySessionStarted(
        topicId: widget.topicId, 
        activity: StudyActivity.practice,
      ),
    );
  }

  @override
  void dispose() {
    _sessionBloc.add(
      const StudySessionCompleted(),
    );

    super.dispose();
  }

  final List<Map<String, String>> practiceQuestions = [
    {
      "image": "assets/images/func.webp",
      "memo": "Step 1: Expand the brackets...\nStep 2: Simplify..."
    },
    {
      "image": "assets/images/summation.webp",
      "memo": "Use factorization..."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice - Algebra"),
      ),
      body: ListView.builder(
        itemCount: practiceQuestions.length,
        itemBuilder: (context, index) {
          final question = practiceQuestions[index];

          return PracticeCard(
            key: ValueKey(index), // IMPORTANT for stability
            imageUrl: question["image"]!,
            memoText: question["memo"]!,
          );
        },
      ),
    );
  }
}