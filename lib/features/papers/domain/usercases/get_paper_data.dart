import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/respositories/papers_respository.dart';

class GetPaperData {
  final PapersTileRepository repository;

  GetPaperData(this.repository);

  Future<List<PaperItem>> call(PaperType type) {
    if (type == PaperType.paper1) {
      return repository.getPaper1Tile();
    } else {
      return repository.getPaper2Tile();
    }
  }
}
