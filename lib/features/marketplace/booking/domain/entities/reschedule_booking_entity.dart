import 'package:equatable/equatable.dart';

class RescheduleBookingEntity extends Equatable {
  final String bookingId;
  final DateTime newScheduledAt;

  const RescheduleBookingEntity({
    required this.bookingId,
    required this.newScheduledAt,
  });

  @override
  List<Object?> get props => [
    bookingId,
    newScheduledAt,
  ];
}
