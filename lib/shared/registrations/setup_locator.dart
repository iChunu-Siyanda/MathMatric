import 'package:math_matric/shared/registrations/ui/register_analytics_streak_module.dart';
import 'package:math_matric/shared/registrations/ui/register_exams_module.dart';
import 'package:math_matric/shared/registrations/repositories/register_local_data_sources.dart';
import 'package:math_matric/shared/registrations/ui/register_papers_module.dart';
import 'package:math_matric/shared/registrations/ui/register_practice_module.dart';
import 'package:math_matric/shared/registrations/ui/register_quiz_module.dart';
import 'package:math_matric/shared/registrations/repositories/register_repository_module.dart';
import 'package:math_matric/shared/registrations/ui/register_study_history_module.dart';

Future<void> setupLocator() async {
  //Firebase
  //registerFirebaseModule();

  //App Database
  //setupDependencies();

  //Study History Bloc:
  registerStudyHistoryModule();

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
