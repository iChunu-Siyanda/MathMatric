// session.id == test-session-001
// session.startedAt == 2026-01-01 10:30
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/local/study_session_local_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/remote/study_session_remote_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/repositories/study_session_local_data_source_impl.dart';
import 'package:math_matric/features/progress/studysession/data/repositories/study_session_remote_data_source_impl.dart';
import 'package:math_matric/features/progress/studysession/data/repositories/study_session_repository_impl.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:math_matric/features/ui/streak/domain/entities/habit_entry.dart';
import 'package:math_matric/features/ui/streak/domain/mapper/habit_entry_mapper.dart';
import 'package:math_matric/features/ui/streak/domain/repositories/habit_repository.dart';
import 'package:math_matric/features/ui/streak/domain/usercase/habit_entry_helper.dart';

import 'fake_clock.dart';
import 'fake_id_generator.dart';

// ALL TESTS PASSED:
// The entire chain is proven:
// Study Activity
//       ↓
// StudySessionBloc
//       ↓
// StudySessionRepository
//       ↓
// Drift
//       ↓
// HabitRepository
//       ↓
// HabitEntryMapper
//       ↓
// Streak calculations
//       ↓
// HabitBloc
//       ↓
// UI

void main() {
  late AppDatabase database;
  late FirebaseFirestore firestore;
  late StudySessionLocalDataSource local;
  late StudySessionRemoteDataSource remote;
  late FakeClock clock;
  late StudySessionRepository repository;
  late FakeIdGenerator idGenerator;
  late HabitRepository habitRepository;

  setUp(() {
    database = AppDatabase.test(
      NativeDatabase.memory(),
    );

    firestore = FakeFirebaseFirestore();

    local = StudySessionLocalDataSourceImpl(database);

    remote = StudySessionRemoteDataSourceImpl(
      firestore,
    );

    clock = FakeClock(DateTime(2026,1,1,10,30)); //year,month,day,hour,minute

    idGenerator = FakeIdGenerator();

    repository = StudySessionRepositoryImpl(
      local,
      remote,
      clock,
      idGenerator,
    );

    habitRepository = HabitRepository(repository,clock);
  });


  tearDown(() async {
    await database.close();
  });

  // SESSION 1: Study Session Lifecycle.
  // Integration Test: StudySessionRepository → Drift persistence. 
  test(
    'startSession and completeSession should persist a completed study session',
    () async {
      final session = await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.practice,
      );

      expect(session.id, 'test-session-001');
      expect(
        session.startedAt,
        DateTime(2026, 1, 1, 10, 30),
      );
      expect(session.endedAt, isNull);
      expect(session.topicId, 'algebra');
      expect(session.activity, StudyActivity.practice);

      // Student studies for 30 minutes.
      clock.advanceBy(const Duration(minutes: 30));

      await repository.completeSession(
        sessionId: session.id,
      );

      final activeSession = await repository.getActiveStudySession();

      expect(activeSession, isNull);

      final sessions = await repository.watchStudySessions().first;

      expect(sessions, hasLength(1));

      final completed = sessions.firstWhere(
        (savedSession) => savedSession.id == session.id,
      );

      expect(
        completed.startedAt,
        DateTime(2026, 1, 1, 10, 30),
      );

      expect(
        completed.endedAt,
        DateTime(2026, 1, 1, 11, 0),
      );

      expect(completed.topicId, 'algebra');
      expect(completed.activity, StudyActivity.practice);
    },
  );

  // SESSION 2: Correctly records the study session.
  // Integration Test, this proves:
  // startSession()
  //     ↓
  // questions = 0
  // correct = 0
  // XP = 0
  //     ↓
  // updateSessionProgress()
  //     ↓
  // questions = 10
  // correct = 8
  // XP = 120
  test(
    'updateSessionProgress should update the active study session',
    () async {
      final session = await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.practice,
      );

      await repository.updateSessionProgress(
        sessionId: session.id,
        questionsAnswered: 10,
        correctAnswers: 8,
        earnedXP: 120,
      );

      final activeSession = await repository.getActiveStudySession();

      expect(activeSession, isNotNull);

      expect(activeSession!.id, session.id);
      expect(activeSession.topicId, 'algebra');
      expect(
        activeSession.activity,
        StudyActivity.practice,
      );

      expect(
        activeSession.questionsAnswered,
        10,
      );

      expect(
        activeSession.correctAnswers,
        8,
      );

      expect(
        activeSession.earnedXP,
        120,
      );

      expect(
        activeSession.endedAt,
        isNull,
      );
    },
  );

  //SESION 3: No duplicate active sessions
  // Integration Test: Active/completed session lifecycle
  // Starting a session creates an active session.
  test(
    'getActiveStudySession should return the currently active session',
    () async {
      final session = await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.practice,
      );

      final activeSession =
          await repository.getActiveStudySession();

      expect(activeSession, isNotNull);
      expect(activeSession!.id, session.id);
      expect(activeSession.topicId, 'algebra');
      expect(
        activeSession.activity,
        StudyActivity.practice,
      );
      expect(activeSession.endedAt, isNull);
    },
  );
  // You cannot accidentally have two active sessions.
  test(
    'completed session should no longer be returned as active',
    () async {
      final session = await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.practice,
      );

      clock.advanceBy(
        const Duration(minutes: 30),
      );

      await repository.completeSession(
        sessionId: session.id,
      );

      final activeSession = await repository.getActiveStudySession();

      expect(activeSession, isNull);
    },
  );
  // Completing a nonexistent session fails.
  test(
    'updateSessionProgress should throw when session does not exist',
    () async {
      expect(
        () => repository.updateSessionProgress(
          sessionId: 'non-existent-session',
          questionsAnswered: 5,
          correctAnswers: 4,
          earnedXP: 50,
        ),
        throwsException,
      );
    },
  );
  // Updating a nonexistent session fails.
  test(
    'completeSession should throw when session does not exist',
    () async {
      expect(
        () => repository.completeSession(
          sessionId: 'non-existent-session',
        ),
        throwsException,
      );
    },
  );

  //SESSION 4: Habit/Steak Pipeline (Unit Test)
  test(
    '15 minutes of study should count as a valid study day',
    () {
      final entry = HabitEntry(
        date: DateTime(2026, 1, 1),
        totalStudyMinutes: 15,
        activities: {StudyActivity.notes},
      );

      expect(
        isValidStudyDay(entry),
        isTrue,
      );
    },
  );

  test(
    'less than 15 minutes of notes should not count as a study day',
    () {
      final entry = HabitEntry(
        date: DateTime(2026, 1, 1),
        totalStudyMinutes: 10,
        activities: {StudyActivity.notes},
      );

      expect(
        isValidStudyDay(entry),
        isFalse,
      );
    },
  );

  test(
    'practice activity should count as a valid study day',
    () {
      final entry = HabitEntry(
        date: DateTime(2026, 1, 1),
        totalStudyMinutes: 1,
        activities: {StudyActivity.practice},
      );

      expect(
        isValidStudyDay(entry),
        isFalse,
      );
    },
  );

  test(
    'past paper activity should count as a valid study day',
    () {
      final entry = HabitEntry(
        date: DateTime(2026, 1, 1),
        totalStudyMinutes: 14,
        activities: {StudyActivity.pastPapers},
      );

      expect(
        isValidStudyDay(entry),
        isFalse,
      );
    },
  );

  //Differentnt Activities must accumulate:
  test(
    'study time from multiple activities should combine toward the 15-minute threshold',
    () {
      final entry = HabitEntry(
        date: DateTime(2026, 1, 1),
        totalStudyMinutes: 15,
        activities: {
          StudyActivity.notes,
          StudyActivity.practice,
        },
      );

      expect(
        isValidStudyDay(entry),
        isTrue,
      );
    },
  );

  //Three consecutive valid days produce a 3-day streak
  test(
    'three consecutive valid study days should produce a 3-day current streak',
    () {
      final entries = [
        HabitEntry(
          date: DateTime(2026, 1, 1),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 2),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 3),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
      ];

      final streak = calculateCurrentStreak(
        entries,
        today: DateTime(2026, 1, 3),
      );

      expect(streak, 3);
    },
  );

  //Missing Day Breakes The Streak
  test(
    'a missing study day should break the current streak',
    () {
      final entries = [
        HabitEntry(
          date: DateTime(2026, 1, 1),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 3),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
      ];

      final streak = calculateCurrentStreak(
        entries,
        today: DateTime(2026, 1, 3),
      );

      expect(streak, 1);
    },
  );

  //Weekly score
  test(
    'weekly progress score should count valid study days out of seven',
    () {
      final entries = [
        HabitEntry(
          date: DateTime(2026, 1, 3),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 2),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 1),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
      ];

      final score = calculateWeeklyProgressScore(
        entries,
        today: DateTime(2026, 1, 3),
      );

      expect(score, 43);
    },
  );

  //Longest Streak:
  //Empty entries; longest streak musst be 0.
  test(
    'longest streak should be zero when there are no entries',
    () {
      final result = calculateLongestStreak([]);

      expect(result, 0);
    },
  );

  test(
    'longest streak should be three for three consecutive valid days',
    () {
      final entries = [
        HabitEntry(
          date: DateTime(2026, 1, 1),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 2),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 3),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
      ];

      final result = calculateLongestStreak(entries);

      expect(result, 3);
    },
  );

  test(
    'longest streak should return the longest consecutive sequence',
    () {
      final entries = [
        // 2-day streak
        HabitEntry(
          date: DateTime(2026, 1, 1),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 2),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),

        // 4-day streak
        HabitEntry(
          date: DateTime(2026, 1, 5),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 6),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 7),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 8),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
      ];

      final result = calculateLongestStreak(entries);

      expect(result, 4);
    },
  );

  test(
    'a gap between valid days should reset the streak',
    () {
      final entries = [
        HabitEntry(
          date: DateTime(2026, 1, 1),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 2),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),

        // Jan 3 is missing

        HabitEntry(
          date: DateTime(2026, 1, 4),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 5),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 6),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
      ];

      final result = calculateLongestStreak(entries);

      expect(result, 3);
    },
  );

  test(
    'an invalid study day should break the longest streak',
    () {
      final entries = [
        HabitEntry(
          date: DateTime(2026, 1, 1),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 2),
          totalStudyMinutes: 5,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 3),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
        HabitEntry(
          date: DateTime(2026, 1, 4),
          totalStudyMinutes: 30,
          activities: {StudyActivity.notes},
        ),
      ];

      final result = calculateLongestStreak(entries);

      expect(result, 2);
    },
  );

  //SESSION 5: HabitEntryMapper (Unit Test)
  // StudySessionData (Drift)
  //         ↓
  // HabitEntryMapper
  //         ↓
  // HabitEntry
  //         ↓
  // streak calculations

  //Prove that HabitEntryMapper takes in multiple sessions on the same day are merged into one HabitEntry, 
  //with their study time added and activities combined.
    
  // Map one session:
  test(
    'should map one study session into one habit entry',
    () {
      final session = StudySessionData(
        id: 'session-1',
        topicId: 'algebra',
        activity: StudyActivity.notes,
        startedAt: DateTime(2026, 1, 1, 10, 0),
        endedAt: DateTime(2026, 1, 1, 10, 30),
        questionsAnswered: 0,
        correctAnswers: 0,
        earnedXP: 0,
        synced: false,
        updatedAt: DateTime(2026, 1, 1, 10, 30),
      );

      final entries = HabitEntryMapper.fromStudySessions(
        [session],
      );

      expect(entries, hasLength(1));

      final entry = entries.first;

      expect(
        entry.date,
        DateTime(2026, 1, 1),
      );

      expect(
        entry.totalStudyMinutes,
        30,
      );

      expect(
        entry.activities,
        {StudyActivity.notes},
      );
    },
  );

  //Multiple sessions on the same day are combined:
  test(
    'should combine multiple study sessions from the same day',
    () {
      final sessions = [
        StudySessionData(
          id: 'session-1',
          topicId: 'algebra',
          activity: StudyActivity.notes,
          startedAt: DateTime(2026, 1, 1, 10, 0),
          endedAt: DateTime(2026, 1, 1, 10, 30),
          questionsAnswered: 0,
          correctAnswers: 0,
          earnedXP: 0,
          synced: false,
          updatedAt: DateTime(2026, 1, 1, 10, 30),
        ),
        StudySessionData(
          id: 'session-2',
          topicId: 'geometry',
          activity: StudyActivity.practice,
          startedAt: DateTime(2026, 1, 1, 14, 0),
          endedAt: DateTime(2026, 1, 1, 14, 45),
          questionsAnswered: 10,
          correctAnswers: 8,
          earnedXP: 100,
          synced: false,
          updatedAt: DateTime(2026, 1, 1, 14, 45),
        ),
      ];

      final entries = HabitEntryMapper.fromStudySessions(
        sessions,
      );

      expect(entries, hasLength(1));

      final entry = entries.first;

      expect(
        entry.totalStudyMinutes,
        75,
      );

      expect(
        entry.activities,
        {
          StudyActivity.notes,
          StudyActivity.practice,
        },
      );
    },
  );

  //Sessions on different days remain separate.
  test(
    'should create separate habit entries for different days',
    () {
      final sessions = [
        StudySessionData(
          id: 'session-1',
          topicId: 'algebra',
          activity: StudyActivity.notes,
          startedAt: DateTime(2026, 1, 1, 10, 0),
          endedAt: DateTime(2026, 1, 1, 10, 30),
          questionsAnswered: 0,
          correctAnswers: 0,
          earnedXP: 0,
          synced: false,
          updatedAt: DateTime(2026, 1, 1, 10, 30),
        ),
        StudySessionData(
          id: 'session-2',
          topicId: 'geometry',
          activity: StudyActivity.practice,
          startedAt: DateTime(2026, 1, 2, 14, 0),
          endedAt: DateTime(2026, 1, 2, 14, 45),
          questionsAnswered: 10,
          correctAnswers: 8,
          earnedXP: 100,
          synced: false,
          updatedAt: DateTime(2026, 1, 2, 14, 45),
        ),
      ];

      final entries = HabitEntryMapper.fromStudySessions(
        sessions,
      );

      expect(entries, hasLength(2));

      expect(
        entries[0].date,
        DateTime(2026, 1, 2),
      );

      expect(
        entries[1].date,
        DateTime(2026, 1, 1),
      );
    },
  );

  //A 15-minute session is represented correctly.
  test(
    'should calculate study duration correctly in minutes',
    () {
      final session = StudySessionData(
        id: 'session-1',
        topicId: 'algebra',
        activity: StudyActivity.practice,
        startedAt: DateTime(2026, 1, 1, 10, 0),
        endedAt: DateTime(2026, 1, 1, 10, 15),
        questionsAnswered: 5,
        correctAnswers: 4,
        earnedXP: 50,
        synced: false,
        updatedAt: DateTime(2026, 1, 1, 10, 15),
      );

      final entries = HabitEntryMapper.fromStudySessions(
        [session],
      );

      expect(
        entries.first.totalStudyMinutes,
        15,
      );
    },
  );


  // SESSION 6: HabitRepository
  // Integration Test: StudySessionRepository → Drift → HabitRepository → streak
  // StudySessionRepository
  //       ↓
  // watchStudySessions()
  //       ↓
  // HabitRepository
  //       ↓
  // HabitEntryMapper
  //       ↓
  // streak calculations
  //       ↓
  // HabitSummary
  
  // Empty database:
  test(
    'watchSummary should return zero values when there are no study sessions',
    () async {
      final summary = await habitRepository.watchSummary().first;

      expect(summary.currentStreak, 0);
      expect(summary.longestStreak, 0);
      expect(summary.weeklyProgressScore, 0);
    },
  );

  // A valid 15-minute session produces a study day:
  test(
    'a completed 15-minute study session should count toward the streak',
    () async {
      await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.practice,
      );

      clock.advanceBy(
        const Duration(minutes: 15),
      );

      final active = await repository.getActiveStudySession();

      expect(active, isNotNull);

      await repository.completeSession(
        sessionId: active!.id,
      );

      final summary = await habitRepository.watchSummary().first;

      expect(summary.currentStreak, 1);
      expect(summary.longestStreak, 1);
      expect(summary.weeklyProgressScore, 14);
    },
  );

  // Two sessions on the same day accumulate:
  test(
    'multiple sessions on the same day should accumulate toward the study-day threshold',
    () async {
      // First session: 7 minutes
      await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.notes,
      );

      clock.advanceBy(
        const Duration(minutes: 7),
      );

      final first = await repository.getActiveStudySession();

      await repository.completeSession(
        sessionId: first!.id,
      );

      // Second session: another 8 minutes
      await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.practice,
      );

      clock.advanceBy(
        const Duration(minutes: 8),
      );

      final second =
          await repository.getActiveStudySession();

      await repository.completeSession(
        sessionId: second!.id,
      );

      final summary =
          await habitRepository.watchSummary().first;

      expect(summary.currentStreak, 1);
      expect(summary.longestStreak, 1);
      expect(summary.weeklyProgressScore, 14);
    },
  );
  
  // 14 minutes does not count:
  test(
    'a study day with less than 15 minutes should not count',
    () async {
      await repository.startSession(
        topicId: 'algebra',
        activity: StudyActivity.practice,
      );

      clock.advanceBy(
        const Duration(minutes: 14),
      );

      final session = await repository.getActiveStudySession();

      await repository.completeSession(
        sessionId: session!.id,
      );

      final summary = await habitRepository.watchSummary().first;

      expect(summary.currentStreak, 0);
      expect(summary.longestStreak, 0);
      expect(summary.weeklyProgressScore, 0);
    },
  ); 

}
