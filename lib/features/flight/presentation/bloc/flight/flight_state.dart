part of 'flight_bloc.dart';

sealed class FlightState extends Equatable {
  const FlightState();

  @override
  List<Object?> get props => [];
}

final class FlightInitial extends FlightState {}

class AirportsLoading extends FlightState {}

class AirportsLoaded extends FlightState {
  final List<AirportEntity> airports;

  const AirportsLoaded(this.airports);

  @override
  List<Object?> get props => [airports];
}

class FlightSearchLoading extends FlightState {}

class FlightSearchLoaded extends FlightState {
  final FlightSearchResultEntity result;

  const FlightSearchLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class FlightSeatsLoading extends FlightState {}

class FlightSeatsLoaded extends FlightState {
  final List<FlightSeatEntity> seats;

  const FlightSeatsLoaded(this.seats);

  @override
  List<Object?> get props => [seats];
}

class FlightError extends FlightState {
  final String message;

  const FlightError(this.message);

  @override
  List<Object?> get props => [message];
}
