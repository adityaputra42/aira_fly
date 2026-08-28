part of 'flight_bloc.dart';

sealed class FlightEvent extends Equatable {
  const FlightEvent();

  @override
  List<Object?> get props => [];
}

class LoadAirportsRequested extends FlightEvent {
  final int page;
  final int limit;

  const LoadAirportsRequested({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class SearchFlightsRequested extends FlightEvent {
  final int departureAirportId;
  final int arrivalAirportId;
  final String date;
  final String tripType;
  final String? returnDate;
  final int? maxStops;
  final int totalPax;
  final int? seatClassId;
  final int page;
  final int limit;

  const SearchFlightsRequested({
    required this.departureAirportId,
    required this.arrivalAirportId,
    required this.date,
    this.tripType = 'one_way',
    this.returnDate,
    this.maxStops,
    required this.totalPax,
    this.seatClassId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [
    departureAirportId,
    arrivalAirportId,
    date,
    tripType,
    returnDate,
    maxStops,
    totalPax,
    seatClassId,
    page,
    limit,
  ];
}

class LoadFlightSeatsRequested extends FlightEvent {
  final int flightId;

  const LoadFlightSeatsRequested({required this.flightId});

  @override
  List<Object?> get props => [flightId];
}
