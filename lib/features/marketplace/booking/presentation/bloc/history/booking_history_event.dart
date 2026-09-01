sealed class BookingHistoryEvent {
  const BookingHistoryEvent();
}

class BookingHistoryRequested extends BookingHistoryEvent {
  const BookingHistoryRequested();
}

class BookingHistoryRefreshRequested extends BookingHistoryEvent {
  const BookingHistoryRefreshRequested();
}
