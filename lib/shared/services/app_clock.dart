abstract class AppClock {
  DateTime now();
}

class AppClockImpl implements AppClock {
  @override
  DateTime now() => DateTime.now();
}
