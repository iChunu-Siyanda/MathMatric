import 'package:math_matric/shared/services/app_clock.dart';

class FakeClock implements AppClock {
  FakeClock(this._currentTime);

  DateTime _currentTime;

  @override
  DateTime now() => _currentTime;

  void advanceTo(DateTime time) {
    _currentTime = time;
  }

  void advanceBy(Duration duration) {
    _currentTime = _currentTime.add(duration);
  }
}

