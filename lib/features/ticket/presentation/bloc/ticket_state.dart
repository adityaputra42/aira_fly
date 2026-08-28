part of 'ticket_bloc.dart';

sealed class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

final class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class CheckedIn extends TicketState {
  final CheckInResultEntity result;

  const CheckedIn(this.result);

  @override
  List<Object?> get props => [result];
}

class BoardingPassLoaded extends TicketState {
  final BoardingPassEntity boardingPass;

  const BoardingPassLoaded(this.boardingPass);

  @override
  List<Object?> get props => [boardingPass];
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object?> get props => [message];
}
