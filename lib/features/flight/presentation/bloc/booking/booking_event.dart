part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class CreatePnrRequested extends BookingEvent {
  final ContactInput contact;
  final List<PassengerInput> passengers;
  final List<BookingSegmentInput> segments;
  final List<SeatSelectionInput> seatSelections;
  final int holdTtlSeconds;

  const CreatePnrRequested({
    required this.contact,
    required this.passengers,
    required this.segments,
    required this.seatSelections,
    this.holdTtlSeconds = 0,
  });

  @override
  List<Object?> get props => [contact, passengers, segments, seatSelections, holdTtlSeconds];
}

class LoadPnrRequested extends BookingEvent {
  final int id;

  const LoadPnrRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadPnrListRequested extends BookingEvent {
  final int page;
  final int limit;
  final String? status;

  const LoadPnrListRequested({this.page = 1, this.limit = 10, this.status});

  @override
  List<Object?> get props => [page, limit, status];
}

/// Self-service history -- login required, always the caller's own
/// bookings. Use for the "Ticket History" tab when signed in.
class LoadMyPnrListRequested extends BookingEvent {
  final int page;
  final int limit;
  final String? status;

  const LoadMyPnrListRequested({this.page = 1, this.limit = 10, this.status});

  @override
  List<Object?> get props => [page, limit, status];
}

/// Guest (signed-out) lookup by booking code. See the warning on
/// BookingRepository.getPnrByBookingCode before assuming this is
/// ownership-checked -- today it isn't, backend-side.
class LoadPnrByBookingCodeRequested extends BookingEvent {
  final String bookingCode;

  const LoadPnrByBookingCodeRequested({required this.bookingCode});

  @override
  List<Object?> get props => [bookingCode];
}

class CancelPnrRequested extends BookingEvent {
  final int id;

  const CancelPnrRequested({required this.id});

  @override
  List<Object?> get props => [id];
}
