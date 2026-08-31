import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/marketplace/booking/data/datasource/booking_remote_datasource.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import '../../models/booking_model.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  BookingRemoteDataSourceImpl({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> get _bookings => firestore.collection(FirestoreCollections.bookings);

  @override
  Future<BookingModel> getBooking(
    String bookingId,
  ) async {
    final doc = await _bookings.doc(bookingId).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('Booking not found');
    }

    return BookingModel.fromMap({
      ...doc.data()!,
      'id': doc.id,
    });
  }

  @override
  Future<List<BookingModel>> getStudentBookings({
    required String studentId,
  }) async {
    final snapshot = await _bookings
        .where(
          'studentId',
          isEqualTo: studentId,
        )
        .orderBy(
          'scheduledAt',
          descending: true,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => BookingModel.fromMap({
            ...doc.data(),
            'id': doc.id,
          }),
        )
        .toList();
  }

  @override
  Future<BookingModel> createBooking(
    BookingModel booking,
  ) async {
    await _bookings
        .doc(booking.id)
        .set(booking.toFirestore());

    return booking;
  }

  @override
  Future<void> cancelBooking(
    String bookingId,
  ) async {
    await _bookings.doc(bookingId).update({
      'status': BookingStatus.cancelled.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<BookingModel>> getConfirmedBookingsForDate({
    required String tutorId,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final endOfDay = startOfDay.add(
      const Duration(days: 1),
    );

    final snapshot = await firestore
        .collection('bookings')
        .where(
          'tutorId',
          isEqualTo: tutorId,
        )
        .where(
          'status',
          isEqualTo: BookingStatus.confirmed.name,
        )
        .where(
          'scheduledAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            startOfDay,
          ),
        )
        .where(
          'scheduledAt',
          isLessThan: Timestamp.fromDate(
            endOfDay,
          ),
        )
        .orderBy('scheduledAt')
        .get();

    return snapshot.docs
        .map(
          (doc) => BookingModel.fromMap(
            doc.data(),
          ),
        )
        .toList();
  }
}
