import 'package:cloud_firestore/cloud_firestore.dart';
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
  });

  factory BookingModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return BookingModel(
      id: map['id'] as String,
      studentId: map['studentId'] as String,
      tutorId: map['tutorId'] as String,

      scheduledAt: (map['scheduledAt'] as Timestamp).toDate(),
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

      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),

      respondedAt: map['respondedAt'] == null
                  ? null
                  : (map['resondedAt'] as Timestamp).toDate(),
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
    };
  }
}
