import 'package:math_matric/shared/services/id_generator.dart';

class FakeIdGenerator implements IdGenerator {
  @override
  String generate() => 'test-session-001';
}
