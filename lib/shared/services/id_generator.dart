import 'package:uuid/uuid.dart';

abstract class IdGenerator {
  String generate();
}

class UuidGenerator implements IdGenerator {
  final Uuid uuid;

  UuidGenerator(this.uuid);

  @override
  String generate() => uuid.v4();
}

