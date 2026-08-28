part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class PnrCreated extends BookingState {
  final PnrEntity pnr;

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

class PnrCancelled extends BookingState {}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
