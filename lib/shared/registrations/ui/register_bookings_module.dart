import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:math_matric/features/marketplace/booking/domain/repositories/booking_repository.dart';
import 'package:math_matric/features/marketplace/booking/domain/repositories/tutor_availability_repository.dart';
import 'package:math_matric/features/marketplace/booking/domain/services/availability_slot_generator.dart';
import 'package:math_matric/features/marketplace/booking/domain/services/booking_conflict_checker.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/cancel_booking.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/create_booking.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/get_confirmed_bookings_for_date.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/get_student_bookings.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/get_tutor_availability_use_case.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/reschedule_booking_use_case.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/availability/availability_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/booking/booking_request_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/cancellation/booking_cancellation_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/history/booking_history_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/reschedule/reschedule_bloc.dart';

final getIt = GetIt.instance;

void registerBookingsModule() {
  //usecases:
  getIt.registerLazySingleton(
    () => CreateBooking(getIt<BookingRepository>(),),
  );

  getIt.registerLazySingleton(
    () => GetTutorAvailabilityUseCase(getIt<TutorAvailabilityRepository>())
  );

  getIt.registerLazySingleton(
    () => GetConfirmedBookingsForDate(getIt<BookingRepository>(),)
  );

  getIt.registerLazySingleton(
    () => CancelBooking(getIt<BookingRepository>(),),  
  );

  getIt.registerLazySingleton(
    () => GetStudentBookings(getIt<BookingRepository>(),),
  );

  getIt.registerLazySingleton(
    () => RescheduleBookingUseCase(getIt<BookingRepository>(),),
  );

  //Bloc:
  getIt.registerFactory(
    () => BookingRequestBloc(createBooking: getIt())
  );

  getIt.registerFactory(
    () => AvailabilityBloc(
      getTutorAvailability: getIt(), 
      getConfirmedBookingsForDate: getIt(), 
      slotGenerator: getIt<AvailabilitySlotGenerator>(), 
      conflictChecker: getIt<BookingConflictChecker>(),
    ),
  );

  getIt.registerFactory(
    () => BookingCancellationBloc(
      cancelBooking: getIt(),
    ),
  );

  getIt.registerFactory(
    () => BookingHistoryBloc(
      getStudentBookings: getIt(), 
      student: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerFactory(
    () => RescheduleBookingBloc(
      rescheduleBooking: getIt(),
    ),
  );
}
