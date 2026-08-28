import 'package:equatable/equatable.dart';

class SegmentEntity extends Equatable {
  final int? flightId;
  final String? flightNumber;
  final int? departureAirportId;
  final String? departureAirportCode;
  final String? departureAirportName;
  final int? arrivalAirportId;
  final String? arrivalAirportCode;
  final String? arrivalAirportName;
  final int? aircraftId;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final String? status;

  const SegmentEntity({
    this.flightId,
    this.flightNumber,
    this.departureAirportId,
    this.departureAirportCode,
    this.departureAirportName,
    this.arrivalAirportId,
    this.arrivalAirportCode,
    this.arrivalAirportName,
    this.aircraftId,
    this.departureTime,
    this.arrivalTime,
    this.status,
  });

  @override
  List<Object?> get props => [
    flightId,
    flightNumber,
    departureAirportId,
    departureAirportCode,
    departureAirportName,
    arrivalAirportId,
    arrivalAirportCode,
    arrivalAirportName,
    aircraftId,
    departureTime,
    arrivalTime,
    status,
  ];
}

class ItineraryFareEntity extends Equatable {
  final int? fareClassId;
  final Map<String, String>? prices; // passenger_type (ADT/CHD/INF) -> price
  final String? currency;
  final int? availableSeats;

  const ItineraryFareEntity({
    this.fareClassId,
    this.prices,
    this.currency,
    this.availableSeats,
  });

  @override
  List<Object?> get props => [fareClassId, prices, currency, availableSeats];
}

class ItineraryEntity extends Equatable {
  final int? stops;
  final List<bool>? aircraftChanged;
  final int? durationMinutes;
  final List<SegmentEntity>? segments;
  final List<ItineraryFareEntity>? fares;

  const ItineraryEntity({
    this.stops,
    this.aircraftChanged,
    this.durationMinutes,
    this.segments,
    this.fares,
  });

  @override
  List<Object?> get props => [
    stops,
    aircraftChanged,
    durationMinutes,
    segments,
    fares,
  ];
}

class FlightSearchResultEntity extends Equatable {
  final String? tripType; // ONE_WAY | ROUND_TRIP
  final List<ItineraryEntity>? departure;
  final List<ItineraryEntity>? returnItineraries;

  const FlightSearchResultEntity({
    this.tripType,
    this.departure,
    this.returnItineraries,
  });

  @override
  List<Object?> get props => [tripType, departure, returnItineraries];
}
