part of 'ticket_bloc.dart';

sealed class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

class CheckInRequested extends TicketEvent {
  final String ticketNumber;
  final int? baggageCount;
  final String? baggageWeightKg;

  const CheckInRequested({required this.ticketNumber, this.baggageCount, this.baggageWeightKg});

  @override
  List<Object?> get props => [ticketNumber, baggageCount, baggageWeightKg];
}

class LoadBoardingPassRequested extends TicketEvent {
  final int passengerId;
  final int segmentId;

  const LoadBoardingPassRequested({required this.passengerId, required this.segmentId});

  @override
  List<Object?> get props => [passengerId, segmentId];
}
