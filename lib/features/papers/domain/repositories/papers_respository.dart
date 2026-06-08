import 'package:math_matric/features/papers/domain/entities/paper_item.dart';

abstract class PapersTileRepository {
  Future<List<PaperItem>> getPaper1Tile();
  Future<List<PaperItem>> getPaper2Tile();
}
