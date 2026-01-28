import 'package:math_matric/features/papers/data/local/papers_item_local_data.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/respositories/papers_respository.dart';

class PapersRepositoryImpl implements PapersTileRepository {
  final PaperTileLocalData localDataSource;

  PapersRepositoryImpl(this.localDataSource);

  @override
  Future<List<PaperItem>> getPaper1Tile() async {
    return PaperTileLocalData().getPaperItems(PaperType.paper1);
  }

  @override
  Future<List<PaperItem>> getPaper2Tile() async {
    return PaperTileLocalData().getPaperItems(PaperType.paper2);
  }
}

//How data is obtained
