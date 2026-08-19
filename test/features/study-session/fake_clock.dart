import 'package:math_matric/shared/services/app_clock.dart';

class FakeClock implements AppClock {
  @override
  DateTime now() => DateTime(2026, 1, 1, 10, 30);
}
