import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';

class QuizContentArea extends StatelessWidget {
  const QuizContentArea({
    super.key,
    required this.currentQuestionNum,
    required this.question,
    required this.options, 
    required this.selectedIndex,
  });

  final int currentQuestionNum;
  final String question;
  final List<String> options;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Number Tag
          Text(
            "QUESTION $currentQuestionNum",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
    
          // Question Body Text
          Text(
            question,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 25),
    
          // Animated Interactive Options
          ...List.generate(options.length, (index) {
            bool isSelected = selectedIndex == index;
    
            return GestureDetector(
              onTap: () {
                context.read<QuizBloc>().add(
                  SelectOptionEvent(index: index),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    /// Container Index Bubble (A, B, C, D)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.blue : Colors.grey.shade100,
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
    
                    // Option Text
                    Expanded(
                      child: Text(
                        options[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? Colors.blue.shade900 : const Color(0xFF334155),
                        ),
                      ),
                    ),
    
                    // Custom Check indicator
                    Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_off,
                      color: isSelected ? Colors.blue : Colors.grey.shade400,
                      size: 22,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
