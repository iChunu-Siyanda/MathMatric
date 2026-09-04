import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_cancellation_reason.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_status.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.studentId,
    required super.tutorId,
    required super.scheduledAt,
    required super.durationMinutes,
    required super.teachingMode,
    required super.priceCents,
    required super.currency,
    required super.status,
    required super.tutorName,
    super.tutorPhotoUrl,
    required super.createdAt,
    required super.updatedAt,
    super.respondedAt,
    super.cancelledBy,
    super.cancelledAt,
    super.cancellationReason,
    super.cancellationComment,
    super.rescheduledAt,
    super.rescheduledBy,
    super.previousScheduledAt,
  });

  factory BookingModel.fromFirestore(
    Map<String, dynamic> map,
  ) {
    final scheduledAt = map['scheduledAt'];
    final createdAt = map['createdAt'];
    final updatedAt = map['updatedAt'];
    final respondedAt = map['respondedAt'];
    final cancelledAt = map['cancelledAt'];

    return BookingModel(
      id: map['id'] as String,
      studentId: map['studentId'] as String,
      tutorId: map['tutorId'] as String,

      scheduledAt: scheduledAt is Timestamp
          ? scheduledAt.toDate()
          : throw const FormatException(
              'scheduledAt must be a Timestamp',
            ),
      durationMinutes: map['durationMinutes'] as int,
      teachingMode: TeachingMode.values.byName(
        map['teachingMode'] as String,
      ),

      priceCents: map['priceCents'] as int,
      currency: map['currency'] as String,

      status: BookingStatus.values.byName(
        map['status'] as String,
      ),
      tutorName: map['tutorName'] as String,
      tutorPhotoUrl: map['tutorPhotoUrl'] as String?,

      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : throw const FormatException(
              'createdAt must be a Timestamp',
            ),
      updatedAt: updatedAt is Timestamp
          ? updatedAt.toDate()
          : throw const FormatException(
              'updatedAt must be a Timestamp',
            ),

      respondedAt: respondedAt is Timestamp
          ? respondedAt.toDate()
          : null,

      cancelledBy: map['cancelledBy'] as String?,
      cancelledAt: cancelledAt is Timestamp
                  ? cancelledAt.toDate()  
                  : null,
      cancellationReason: map['cancellationReason'] != null
                        ? BookingCancellationReason.values.byName(map['cancellationReason'] as String,)
                        : null,
      cancellationComment: map['cancellationComment'] as String?,

      rescheduledAt: map['rescheduledAt'] != null
          ? (map['rescheduledAt'] as Timestamp).toDate()
          : null,

      rescheduledBy: map['rescheduledBy'] as String?,

      previousScheduledAt: map['previousScheduledAt'] != null
          ? (map['previousScheduledAt'] as Timestamp).toDate()
          : null,
          );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'studentId': studentId,
      'tutorId': tutorId,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'durationMinutes': durationMinutes,
      'teachingMode': teachingMode.name,
      'priceCents': priceCents,
      'currency': currency,
      'status': status.name,
      'tutorName': tutorName,
      'tutorPhotoUrl': tutorPhotoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'respondedAt': respondedAt == null
                    ? null
                    : Timestamp.fromDate(respondedAt!),
      'cancelledBy': cancelledBy,
      'cancelledAt': cancelledAt == null ? null : Timestamp.fromDate(cancelledAt!),
      'cancellationReason': cancellationReason,  
      'cancellationComment': cancellationComment, 
      'rescheduledAt': rescheduledAt,
      'rescheduledBy': rescheduledBy,
      'previousScheduledAt': previousScheduledAt,          
    };
  }
}
