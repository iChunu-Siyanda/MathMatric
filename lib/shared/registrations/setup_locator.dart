import 'package:math_matric/shared/registrations/register_analytics_streak_module.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';
import 'package:math_matric/shared/registrations/register_papers_module.dart';
import 'package:math_matric/shared/registrations/register_practice_module.dart';
import 'package:math_matric/shared/registrations/register_quiz_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupLocator(SharedPreferences prefs) async {
  //Firebase
  //registerFirebaseModule();

  //App Database
  //setupDependencies();

  //Analytics & Streak
  registerAnalyticsStreaakModule();

  //Exam
  registerExamsModule();

  //Paper
  registerPapersModule(); 

  //Practice
  registerPracticeModule(prefs);

  //Quiz
  registerQuizModule();
}
