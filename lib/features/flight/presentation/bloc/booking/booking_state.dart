part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class PnrCreated extends BookingState {
  final PnrDetailEntity pnr;

  const PnrCreated(this.pnr);

  @override
  List<Object?> get props => [pnr];
}

class PnrDetailLoaded extends BookingState {
  final PnrDetailEntity pnr;

  const PnrDetailLoaded(this.pnr);

  @override
  List<Object?> get props => [pnr];
}

class PnrListLoaded extends BookingState {
  final List<PnrSummaryEntity> pnrs;

  const PnrListLoaded(this.pnrs);

  @override
  List<Object?> get props => [pnrs];
}

/// Result of [LoadMyPnrListRequested] -- kept distinct from
/// [PnrListLoaded] (the admin listPnrs result) even though the row shape
/// is the same, so a BlocListener/Builder can't accidentally treat "my
/// history loaded" and "admin's global list loaded" as the same event.
class MyPnrListLoaded extends BookingState {
  final List<PnrSummaryEntity> pnrs;

  const MyPnrListLoaded(this.pnrs);

  @override
  List<Object?> get props => [pnrs];
}

/// Result of [LoadPnrByBookingCodeRequested] -- kept distinct from
/// [PnrDetailLoaded] (the admin getPnr-by-id result) for the same reason.
class PnrByBookingCodeLoaded extends BookingState {
  final PnrDetailEntity pnr;

  const PnrByBookingCodeLoaded(this.pnr);

  @override
  List<Object?> get props => [pnr];
}

class PnrCancelled extends BookingState {}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
