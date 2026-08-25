// Drift
//   ↓
// StudySessionRepository
//   ↓
// AnalyticsRepository
//   ↓
// AnalyticsUseCase
//   ↓
// AnalyticsMetrics
//   ↓
// AnalyticsBloc
//   ↓
// Analytics UI

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/ui/analytics/data/repositories/analytics_local_data_source_impl.dart';
import 'package:math_matric/features/ui/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

void main() {
  late AppDatabase database;
  late AnalyticsLocalDataSourceImpl local;
  late AnalyticsRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.test(
      NativeDatabase.memory(),
    );

    local = AnalyticsLocalDataSourceImpl(database);
    repository = AnalyticsRepositoryImpl(local);
  });

  tearDown(() async {
    await database.close();
  });

  //SECTION 1: 
  // 1A: Empty database.
  test(
    'returns empty analytics data when database is empty',
    () async {
      final sessions = await repository.getStudySessionsSince(null);

      final attempts = await repository.getQuestionAttemptsSince(null);

      final levels = await repository.getLevelProgressSince(null);

      final topics = await repository.getTopicProgress();

      expect(sessions, isEmpty);
      expect(attempts, isEmpty);
      expect(levels, isEmpty);
      expect(topics, isEmpty);
    },
  );
  
  // 1B: Study sessions
  test(
    'returns study sessions from local database',
    () async {
      final startedAt = DateTime(2026, 1, 1, 10, 30);
      final endedAt = DateTime(2026, 1, 1, 11, 00);

      await database.into(database.studySession).insert(
        StudySessionCompanion.insert(
          id: 'session-001',
          topicId: 'algebra',
          activity: StudyActivity.practice,
          startedAt: startedAt,
          endedAt: Value(endedAt),
          questionsAnswered: 10,
          correctAnswers: 8,
          earnedXP: 100,
          synced: const Value(false),
          updatedAt: startedAt,
        ),
      );

      final sessions = await repository.getStudySessionsSince(null);

      expect(sessions, hasLength(1));

      final session = sessions.first;

      expect(session.id, 'session-001');
      expect(session.topicId, 'algebra');
      expect(session.activity, StudyActivity.practice);
      expect(session.startedAt, startedAt);
      expect(session.endedAt, endedAt);
      expect(session.questionsAnswered, 10);
      expect(session.correctAnswers, 8);
      expect(session.earnedXP, 100);
    },
  );

  // 1C: since timeframe filtering.
  test(
    'returns only study sessions after the since date',
    () async {
      await database.batch((batch){
        batch.insertAll(
          database.studySession,
          [
            StudySessionCompanion.insert(
              id: 'old-session',
              topicId: 'algebra',
              activity: StudyActivity.practice,
              startedAt: DateTime(2026, 1, 1, 10),
              endedAt: Value(
                DateTime(2026, 1, 1, 10, 30),
              ),
              questionsAnswered: 10,
              correctAnswers: 8,
              earnedXP: 100,
              updatedAt: DateTime(2026, 1, 1, 10),
            ),
            StudySessionCompanion.insert(
              id: 'new-session',
              topicId: 'geometry',
              activity: StudyActivity.pastPapers,
              startedAt: DateTime(2026, 1, 10, 10),
              endedAt: Value(
                DateTime(2026, 1, 10, 10, 30),
              ),
              questionsAnswered: 10,
              correctAnswers: 9,
              earnedXP: 120,
              updatedAt: DateTime(2026, 1, 10, 30),
            ),
          ],
        );}
      );

      final sessions = await repository.getStudySessionsSince(
        DateTime(2026, 1, 5),
      );

      expect(sessions, hasLength(1));
      expect(sessions.first.id, 'new-session');
    },
  );

  // 1D: Question attempts.
  test(
    'returns question attempts from local database',
    () async {
      await database.into(database.questionAttempts).insert(
        QuestionAttemptsCompanion.insert(
          id: 'attempt-001',
          levelId: 'level-1',
          questionId: 'question-1',
          correct: true,
          timeTaken: 12,
          answeredAt: DateTime(2026, 1, 5, 10), 
          updatedAt: DateTime(2026, 1, 5, 10),
        ),
      );

      final attempts = await repository.getQuestionAttemptsSince(null);

      expect(attempts, hasLength(1));

      final attempt = attempts.first;

      expect(attempt.id, 'attempt-001');
      expect(attempt.levelId, 'level-1');
      expect(attempt.questionId, 'question-1');
      expect(attempt.correct, isTrue);
      expect(attempt.timeTaken, 12);
    },
  );

  // 1E: Level progress.
  test(
    'returns level progress from local database',
    () async {
      final lastPlayed = DateTime(2026, 1, 5, 10);

      await database.into(database.userLevelProgresses).insert(
        UserLevelProgressesCompanion.insert(
          id: 'progress-001',
          levelId: 'level-1',
          topicId: 'algebra',
          completed: true,
          earnedXP: 150,
          bestScore: 0.85,
          attempts: 2,
          completedAt: Value(lastPlayed),
          lastPlayed: lastPlayed,
          bestTime: const Value(30), 
          updatedAt: lastPlayed,
        ),
      );

      final levels = await repository.getLevelProgressSince(null);

      expect(levels, hasLength(1));

      final level = levels.first;

      expect(level.id, 'progress-001');
      expect(level.levelId, 'level-1');
      expect(level.topicId, 'algebra');
      expect(level.completed, isTrue);
      expect(level.earnedXP, 150);
      expect(level.bestScore, 0.85);
      expect(level.attempts, 2);
    },
  );
  
  // 1F: Topic progress.
  test(
    'returns all topic progress from local database',
    () async {
      await database.into(database.userTopicProgresses).insert(
        UserTopicProgressesCompanion.insert(
          id: 'topic-progress-001',
          topicId: 'algebra',
          earnedXP: 500,
          mastery: 0.82,
          lastPlayed: DateTime(2026, 1, 5),
          favorite: true, 
          updatedAt: DateTime(2026, 1, 5),
        ),
      );

      final topics =
          await repository.getTopicProgress();

      expect(topics, hasLength(1));

      final topic = topics.first;

      expect(topic.id, 'topic-progress-001');
      expect(topic.topicId, 'algebra');
      expect(topic.earnedXP, 500);
      expect(topic.mastery, 0.82);
      expect(topic.favorite, isTrue);
    },
  );



}
