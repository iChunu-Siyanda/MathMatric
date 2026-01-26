import 'package:math_matric/features/papers/data/local/papers_item_local_data.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/respositories/papers_respository.dart';

class PapersRepositoryImpl implements PapersTileRepository {
  final PaperTileLocalData localDataSource;

  PapersRepositoryImpl(this.localDataSource);

  Future<PaperItem> getPaperData(PaperType type) async {
    //final items = localDataSource.getItems(type);
    return PaperItem(
      title: type == PaperType.paper1 ? 'Paper 1' : 'Paper 2',
      brief: '',
      section: Section(title: "", topics: [])
      //section: Section(title: "", topics: type == PaperType.paper1 ? items.expand((e) => e.section!.topics).toList():items.expand((e) => e.topics).toList(),), 
    );
  }

  @override
  Future<List<PaperItem>> getPaper1Tile() async {
    return PaperTileLocalData().getItems(PaperType.paper1);
  }

  @override
  Future<List<PaperItem>> getPaper2Tile() async {
    return PaperTileLocalData().getItems(PaperType.paper2);
  }
}

//How data is obtained
