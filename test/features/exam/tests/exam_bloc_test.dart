import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_bloc.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_event.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_state.dart';

import '../usecases/failing_open_exam_paper_use_case.dart';
import '../usecases/mock_download_bloc_exam_paper_use_case.dart';
import '../usecases/mock_get_exam_paper_pages_use_case.dart';
import '../usecases/mock_get_exam_paper_use_case.dart';
import '../usecases/mock_get_exam_papers_use_case.dart';
import '../usecases/mock_open_exam_paper_use_case.dart';

void main() {
  late MockGetExamPapersUseCase getExamPapers;
  late MockGetExamPaperUseCase getExamPaper;
  late MockGetExamPaperPagesUseCase getExamPaperPages;
  late MockOpenExamPaperUseCase openExamPaper;
  late MockDownloadBlocExamPaperUseCase downloadExamPaper;
  late FailingOpenExamPaperUseCase failOpenExamPaper;
  late ExamBloc bloc;

  final paper = ExamPaperEntity(
    id: 'paper-1',
    subjectId: 'mathematics',
    paperType: 'paper1',
    session: 'november',
    title: 'Mathematics Paper 1',
    isMemo: false,
    storagePath: 'exam-papers/math/2025/november/paper-1',
    isNational: true,
    year: 2025,
    pageCount: 3,
    downloaded: false,
  );

  setUp(() {
    getExamPapers = MockGetExamPapersUseCase();
    getExamPaper = MockGetExamPaperUseCase();
    getExamPaperPages = MockGetExamPaperPagesUseCase();
    openExamPaper = MockOpenExamPaperUseCase();
    failOpenExamPaper = FailingOpenExamPaperUseCase();
    downloadExamPaper = MockDownloadBlocExamPaperUseCase();

    bloc = ExamBloc(
      getExamPapers: getExamPapers,
      getExamPaper: getExamPaper,
      openExamPaper: openExamPaper,
      downloadExamPaper: downloadExamPaper,
    );
  });

  tearDown(() async { await bloc.close(); });

  test('initial state is ExamInitial', () {
    expect(
      bloc.state,
      isA<ExamInitial>(),
    );
  });

  test(
    'ExamPapersRequested emits loading then list loaded',
    () async {
      getExamPapers.papers = [paper];

      final states = <ExamState>[];

      final subscription = bloc.stream.listen(states.add);

      bloc.add(
        const ExamPapersRequested(
          subjectId: 'mathematics',
          paperType: 'paper1',
          session: 'november',
          year: 2025,
        ),
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 50),
      );

      await subscription.cancel();

      expect(states.length, 2);

      expect(
        states[0],
        isA<ExamLoading>(),
      );

      expect(
        states[1],
        isA<ExamPaperListLoaded>(),
      );

      final loaded = states[1] as ExamPaperListLoaded;

      expect(loaded.papers.length, 1);
      expect(loaded.papers.first.id, 'paper-1');

      expect(
        getExamPapers.receivedSubjectId,
        'mathematics',
      );

      expect(
        getExamPapers.receivedPaperType,
        'paper1',
      );

      expect(
        getExamPapers.receivedSession,
        'november',
      );

      expect(
        getExamPapers.receivedYear,
        2025,
      );
    },
  );

  test(
    'ExamPaperRequested emits loading then paper loaded',
    () async {
      getExamPaper.paper = paper;

      final states = <ExamState>[];

      final subscription = bloc.stream.listen(states.add);

      bloc.add(
        const ExamPaperRequested(
          paperId: 'paper-1',
        ),
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 50),
      );

      await subscription.cancel();

      expect(states.length, 2);

      expect(
        states[0],
        isA<ExamLoading>(),
      );

      expect(
        states[1],
        isA<ExamPaperLoaded>(),
      );

      final loaded =
          states[1] as ExamPaperLoaded;

      expect(
        loaded.paper.id,
        'paper-1',
      );
    },
  );

  test(
    'ExamPaperRequested emits error when paper does not exist',
    () async {
      final states = <ExamState>[];

      final subscription = bloc.stream.listen(states.add);

      bloc.add(
        const ExamPaperRequested(
          paperId: 'missing-paper',
        ),
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 50),
      );

      await subscription.cancel();

      expect(states.length, 2);

      expect(
        states[0],
        isA<ExamLoading>(),
      );

      expect(
        states[1],
        isA<ExamError>(),
      );

      final error =
          states[1] as ExamError;

      expect(
        error.message,
        'Exam paper not found.',
      );
    },
  );

  test('loads exam paper pages successfully', () async {
    final paper = ExamPaperEntity(
      id: 'paper-1',
      subjectId: 'math',
      paperType: 'paper1',
      session: 'november',
      title: 'Mathematics Paper 1',
      isMemo: false,
      storagePath: 'exam-papers/math/paper-1',
      isNational: true,
      year: 2025,
      pageCount: 2,
    );

    openExamPaper.pages = [
      '/local/exam_papers/paper-1/p-01.webp',
      '/local/exam_papers/paper-1/p-02.webp',
    ];

    bloc.add(
      ExamPaperPagesRequested(
        paper: paper,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ExamLoading>(),
        isA<ExamPaperPagesLoaded>()
            .having(
              (state) => state.paper.id,
              'paper id',
              'paper-1',
            )
            .having(
              (state) => state.pages.length,
              'page count',
              2,
            ),
      ]),
    );

    expect(openExamPaper.receivedPaper?.id, 'paper-1');
  });

  test('emits ExamError when opening exam paper fails', () async {
    final paper = ExamPaperEntity(
      id: 'paper-1',
      subjectId: 'math',
      paperType: 'paper1',
      session: 'november',
      title: 'Mathematics Paper 1',
      isMemo: false,
      storagePath: 'exam-papers/math/paper-1',
      isNational: true,
      year: 2025,
      pageCount: 2,
    );

    bloc.close();

    bloc = ExamBloc(
      getExamPapers: getExamPapers,
      getExamPaper: getExamPaper,
      openExamPaper: failOpenExamPaper, 
      downloadExamPaper: downloadExamPaper,
    );

    bloc.add(
      ExamPaperPagesRequested(
        paper: paper,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ExamLoading>(),
        isA<ExamError>(),
      ]),
    );
  });


  test(
    'ExamPaperPagesRequested emits pages loaded',
    () async {
      getExamPaperPages.pages = [
        '/local/paper-1/p-01.webp',
        '/local/paper-1/p-02.webp',
        '/local/paper-1/p-03.webp',
      ];

      final states = <ExamState>[];

      final subscription = bloc.stream.listen(states.add);

      bloc.add(
        ExamPaperPagesRequested(
          paper: paper,
        ),
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 50),
      );

      await subscription.cancel();

      expect(states.length, 1);

      expect(
        states.first,
        isA<ExamPaperPagesLoaded>(),
      );

      final loaded =
          states.first as ExamPaperPagesLoaded;

      expect(
        loaded.paper.id,
        'paper-1',
      );

      expect(
        loaded.pages,
        [
          '/local/paper-1/p-01.webp',
          '/local/paper-1/p-02.webp',
          '/local/paper-1/p-03.webp',
        ],
      );
    },
  );

  test(
    'ExamPaperDownloadRequested downloads paper',
    () async {
      final states = <ExamState>[];

      final subscription = bloc.stream.listen(states.add);

      bloc.add(
        ExamPaperDownloadRequested(
          paper: paper,
        ),
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 50),
      );

      await subscription.cancel();

      expect(states.length, 2);

      expect(
        states[0],
        isA<ExamPaperDownloading>(),
      );

      expect(
        states[1],
        isA<ExamPaperLoaded>(),
      );

      expect(
        downloadExamPaper.downloadedPaper?.id,
        'paper-1',
      );

      final loaded =
          states[1] as ExamPaperLoaded;

      expect(
        loaded.paper.downloaded,
        true,
      );
    },
  );

  test(
    'ResetExamPapers returns to initial state',
    () async {
      bloc.add(
        const ResetExamPapers(),
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 20),
      );

      expect(
        bloc.state,
        isA<ExamInitial>(),
      );
    },
  );
}
