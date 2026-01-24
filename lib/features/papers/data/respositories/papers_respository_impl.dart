import 'package:math_matric/features/papers/data/local/papers_item_local_data.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/respositories/papers_respository.dart';

class PapersRepositoryImpl implements PapersRepository {
  final PapersLocalData localDataSource;

  PapersRepositoryImpl(this.localDataSource);

  Future<PaperItem> getPaperData(PaperType type) async {
    //final items = localDataSource.getItems(type);

    return PaperItem(
      title: type == PaperType.paper1 ? 'Paper 1' : 'Paper 2',
      brief: '',
      section: Section(title: "", topics: []), //items.expand((e) => e.section.topics).toList():items.expand((e) => e.topics).toList(),
    );
  }

  @override
  Future<ExamPaper> getPaper1() {
    // TODO: implement getPaper1
    throw UnimplementedError();
  }

  @override
  Future<ExamPaper> getPaper2() {
    // TODO: implement getPaper2
    throw UnimplementedError();
  }
}

//How data is obtained
