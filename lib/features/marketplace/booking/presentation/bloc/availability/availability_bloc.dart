import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/tutor_availability.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/get_tutor_availability_use_case.dart';
import '../../../domain/services/availability_slot_generator.dart';
import '../../../domain/services/booking_conflict_checker.dart';
import '../../../domain/usecases/get_confirmed_bookings_for_date.dart';

import 'availability_event.dart';
import 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final GetTutorAvailabilityUseCase getTutorAvailability;
  final GetConfirmedBookingsForDate getConfirmedBookingsForDate;

  final AvailabilitySlotGenerator slotGenerator;
  final BookingConflictChecker conflictChecker;

  String? _tutorId;
  DateTime? _date;
  int? _durationMinutes;
  TutorAvailability? _availability;

  AvailabilityBloc({
    required this.getTutorAvailability,
    required this.getConfirmedBookingsForDate,
    required this.slotGenerator,
    required this.conflictChecker,
  }) : super(const AvailabilityInitial(),) {
    on<AvailabilityRequested>(_onAvailabilityRequested,);
    on<AvailabilityDateChanged>(_onDateChanged,);
    on<AvailabilityDurationChanged>(_onDurationChanged,);
    on<AvailabilityRefreshRequested>(_onRefresh,);
  }

  Future<void> _onAvailabilityRequested(
    AvailabilityRequested event,
    Emitter<AvailabilityState> emit,
  ) async {
    if (_tutorId != event.tutorId) {
      _availability = null;
    }
    _tutorId = event.tutorId;
    _date = event.date;
    _durationMinutes = event.durationMinutes;

    await _loadAvailability(emit);
  }

  Future<void> _onDateChanged(
    AvailabilityDateChanged event,
    Emitter<AvailabilityState> emit,
  ) async {
    if (_tutorId == null ||
        _durationMinutes == null) {
      return;
    }

    _date = event.date;

    await _loadAvailability(emit);
  }

  Future<void> _onDurationChanged(
    AvailabilityDurationChanged event,
    Emitter<AvailabilityState> emit,
  ) async {
    if (_tutorId == null ||
        _date == null) {
      return;
    }

    _durationMinutes = event.durationMinutes;

    await _loadAvailability(emit);
  }

  Future<void> _onRefresh(
    AvailabilityRefreshRequested event,
    Emitter<AvailabilityState> emit,
  ) async {
    if (_tutorId == null || _date == null || _durationMinutes == null) {
      return;
    }

    await _loadAvailability(emit);
  }

  Future<void> _loadAvailability(
    Emitter<AvailabilityState> emit,
  ) async {
    final tutorId = _tutorId;
    final date = _date;
    final durationMinutes = _durationMinutes;

    if (tutorId == null || date == null || durationMinutes == null) {
      return;
    }

    emit(const AvailabilityLoading());

    try {
      _availability ??= await getTutorAvailability(tutorId);

      final availability = _availability!;

      final confirmedBookings = await getConfirmedBookingsForDate(
        tutorId: tutorId,
        date: date,
      );

      final weekday = date.weekday;

      final windows = availability.weeklySchedule[weekday] ?? const [];

      final candidateSlots = slotGenerator.generateSlots(
        date: date,
        durationMinutes: durationMinutes,
        windows: windows,
      );

      final availableSlots = conflictChecker.removeConflictingSlots(
        slots: candidateSlots,
        slotDurationMinutes: durationMinutes,
        bookings: confirmedBookings,
      );

      final slots = availableSlots.map(
        (start) => AvailableSlot(
          start: start,
          end: start.add(Duration(minutes: durationMinutes,),),
        ),
      )
      .toList();

      emit(
        AvailabilityLoaded(
          tutorId: tutorId,
          date: date,
          durationMinutes: durationMinutes,
          slots: slots,
        ),
      );
    } catch (e) {
      emit(
        AvailabilityError(
          e.toString(),
        ),
      );
    }
  }
}
