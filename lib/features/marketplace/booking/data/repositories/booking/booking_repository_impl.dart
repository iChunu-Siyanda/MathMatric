import 'package:math_matric/features/marketplace/booking/data/datasource/booking_remote_datasource.dart';

import '../../../domain/entities/booking_entity.dart';
import '../../../domain/repositories/booking_repository.dart';
import '../../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<BookingEntity> getBooking(
    String bookingId,
  ) {
    return remoteDataSource.getBooking(bookingId);
  }

  @override
  Future<List<BookingEntity>> getStudentBookings({
    required String studentId,
  }) {
    return remoteDataSource.getStudentBookings(
      studentId: studentId,
    );
  }

  @override
  Future<BookingEntity> createBooking(
    BookingEntity booking,
  ) {
    return remoteDataSource.createBooking(
      booking as BookingModel,
    );
  }

  @override
  Future<void> cancelBooking(
    String bookingId,
  ) {
    return remoteDataSource.cancelBooking(
      bookingId,
    );
  }

  @override
  Future<List<BookingEntity>> getConfirmedBookingsForDate({
    required String tutorId,
    required DateTime date,
  }) {
    return remoteDataSource.getConfirmedBookingsForDate(
      tutorId: tutorId,
      date: date,
    );
  }
}
