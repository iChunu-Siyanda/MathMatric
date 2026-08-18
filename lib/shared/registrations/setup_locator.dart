import 'package:math_matric/shared/registrations/register_analytics_streak_module.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';
import 'package:math_matric/shared/registrations/register_local_data_sources.dart';
import 'package:math_matric/shared/registrations/register_papers_module.dart';
import 'package:math_matric/shared/registrations/register_practice_module.dart';
import 'package:math_matric/shared/registrations/register_quiz_module.dart';
import 'package:math_matric/shared/registrations/register_repository_module.dart';

Future<void> setupLocator() async {
  //Firebase
  //registerFirebaseModule();

  //App Database
  //setupDependencies();

  // Repositories
  registerRepositoryModule();

  //Local repos
  registerLocalDataSourceModule();

  //Remote repos
  //registerRemoteDataSourceModule();

  //Analytics & Streak
  registerAnalyticsStreakModule();

  //Exam
  registerExamsModule();

  //Paper
  registerPapersModule(); 

  //Practice
  registerPracticeModule();

  //Quiz
  registerQuizModule();

 // Services
 //registerServiceModule();
}
