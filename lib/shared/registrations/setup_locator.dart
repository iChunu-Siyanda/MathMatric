import 'package:math_matric/shared/registrations/dependencies/register_app_database_module.dart';
import 'package:math_matric/shared/registrations/dependencies/register_firebase_module.dart';
import 'package:math_matric/shared/registrations/repositories/register_remote_data_source_module.dart';
import 'package:math_matric/shared/registrations/services/register_services_module.dart';
import 'package:math_matric/shared/registrations/ui/register_analytics_streak_module.dart';
import 'package:math_matric/shared/registrations/ui/register_class_notes_module.dart';
import 'package:math_matric/shared/registrations/ui/register_exams_module.dart';
import 'package:math_matric/shared/registrations/repositories/register_local_data_sources.dart';
import 'package:math_matric/shared/registrations/ui/register_papers_module.dart';
import 'package:math_matric/shared/registrations/ui/register_practice_module.dart';
import 'package:math_matric/shared/registrations/ui/register_quiz_module.dart';
import 'package:math_matric/shared/registrations/repositories/register_repository_module.dart';
import 'package:math_matric/shared/registrations/ui/register_study_history_module.dart';
import 'package:math_matric/shared/registrations/ui/register_study_session_module.dart';
import 'package:math_matric/shared/registrations/ui/register_user_progress_module.dart';

Future<void> setupLocator() async {
  // ==================================
  // CORE:
  // ==================================
  //Firebase
  registerFirebaseModule();

  //App Database
  setupDependencies();

  // ==================================
  // REPOS:
  // ==================================

  // Repositories
  registerRepositoryModule();

  //Local repos
  registerLocalDataSourceModule();

  //Remote repos
  registerRemoteDataSourceModule();

  // ===================================
  // UI:
  // ===================================

  //Study History:
  registerStudyHistoryModule();

  //Study Session:
  registerStudySessionModule();

  //User Progress:
  registerUserProgressModule();

  //Analytics & Streak
  registerAnalyticsStreakModule();

  //Class
  registerClassNotesModule();

  //Exam
  registerExamsModule();

  //Paper
  registerPapersModule(); 

  //Practice
  registerPracticeModule();

  //Quiz
  registerQuizModule();
 
  //======================================
  // Services
  registerServiceModule();
}
