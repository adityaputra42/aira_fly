import '../../domain/entities/itinerary_entity.dart';

/// Maps `segmentResponse` from GET /flights/search (snake_case json tags).
class SegmentModel extends SegmentEntity {
  const SegmentModel({
    super.flightId,
    super.flightNumber,
    super.departureAirportId,
    super.departureAirportCode,
    super.departureAirportName,
    super.arrivalAirportId,
    super.arrivalAirportCode,
    super.arrivalAirportName,
    super.aircraftId,
    super.departureTime,
    super.arrivalTime,
    super.status,
  });

  factory SegmentModel.fromJson(Map<String, dynamic> json) {
    return SegmentModel(
      flightId: json['flight_id'] as int?,
      flightNumber: json['flight_number'] as String?,
      departureAirportId: json['departure_airport_id'] as int?,
      departureAirportCode: json['departure_airport_code'] as String?,
      departureAirportName: json['departure_airport_name'] as String?,
      arrivalAirportId: json['arrival_airport_id'] as int?,
      arrivalAirportCode: json['arrival_airport_code'] as String?,
      arrivalAirportName: json['arrival_airport_name'] as String?,
      aircraftId: json['aircraft_id'] as int?,
      departureTime: json['departure_time'] == null
          ? null
          : DateTime.tryParse(json['departure_time']),
      arrivalTime: json['arrival_time'] == null
          ? null
          : DateTime.tryParse(json['arrival_time']),
      status: json['status'] as String?,
    );
  }
}

/// Maps `fareResponse` from GET /flights/search.
class ItineraryFareModel extends ItineraryFareEntity {
  const ItineraryFareModel({
    super.fareClassId,
    super.prices,
    super.currency,
    super.availableSeats,
  });

  factory ItineraryFareModel.fromJson(Map<String, dynamic> json) {
    final rawPrices = json['prices'] as Map<String, dynamic>?;
    return ItineraryFareModel(
      fareClassId: json['fare_class_id'] as int?,
      prices: rawPrices?.map((k, v) => MapEntry(k, v.toString())),
      currency: json['currency'] as String?,
      availableSeats: json['available_seats'] as int?,
    );
  }
}

/// Maps `itineraryResponse` from GET /flights/search.
class ItineraryModel extends ItineraryEntity {
  const ItineraryModel({
    super.stops,
    super.aircraftChanged,
    super.durationMinutes,
    super.segments,
    super.fares,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      stops: json['stops'] as int?,
      aircraftChanged: (json['aircraft_changed'] as List?)
          ?.map((e) => e as bool)
          .toList(),
      durationMinutes: json['duration_minutes'] as int?,
      segments: (json['segments'] as List?)
          ?.map((e) => SegmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      fares: (json['fares'] as List?)
          ?.map((e) => ItineraryFareModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Maps `searchResponse` from GET /flights/search.
class FlightSearchResultModel extends FlightSearchResultEntity {
  const FlightSearchResultModel({
    super.tripType,
    super.departure,
    super.returnItineraries,
  });

  factory FlightSearchResultModel.fromJson(Map<String, dynamic> json) {
    return FlightSearchResultModel(
      tripType: json['trip_type'] as String?,
      departure: (json['departure'] as List?)
          ?.map((e) => ItineraryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      returnItineraries: (json['return'] as List?)
          ?.map((e) => ItineraryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
