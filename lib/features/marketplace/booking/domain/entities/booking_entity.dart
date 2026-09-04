import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_cancellation_reason.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'booking_status.dart';

class BookingEntity extends Equatable {
  final String id;
  final String studentId;
  final String tutorId;

  final DateTime scheduledAt;
  final int durationMinutes;

  final TeachingMode teachingMode;

  // Stored in cents
  final int priceCents;
  final String currency;

  final BookingStatus status;

  // Snapshot of tutor information at booking time
  final String tutorName;
  final String? tutorPhotoUrl;

  final DateTime createdAt;
  final DateTime updatedAt;

  final DateTime? respondedAt;

  // Cancellation
  final String? cancelledBy;
  final BookingCancellationReason? cancellationReason;
  final String? cancellationComment;
  final DateTime? cancelledAt;

  // Reschedule
  final DateTime? rescheduledAt;
  final String? rescheduledBy;
  final DateTime? previousScheduledAt;

  const BookingEntity({
    required this.id,
    required this.studentId,
    required this.tutorId,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.teachingMode,
    required this.priceCents,
    required this.currency,
    required this.status,
    required this.tutorName,
    this.tutorPhotoUrl,
    required this.createdAt,
    required this.updatedAt, 
    this.respondedAt, 
    this.cancelledBy, 
    this.cancelledAt, 
    this.cancellationReason, 
    this.cancellationComment, 
    this.rescheduledAt, 
    this.rescheduledBy, 
    this.previousScheduledAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    tutorId,
    scheduledAt,
    durationMinutes,
    teachingMode,
    priceCents,
    currency,
    status,
    tutorName,
    tutorPhotoUrl,
    createdAt,
    updatedAt,
    respondedAt,
    cancelledBy,
    cancelledAt,
    cancellationComment,
    cancellationReason,
    rescheduledAt, 
    rescheduledBy,
    previousScheduledAt,
  ];
}
