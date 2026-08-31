import 'package:equatable/equatable.dart';

class AvailabilityWindow extends Equatable {
  final String start;
  final String end;

  const AvailabilityWindow({
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [start, end];
}
