import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/airport_entity.dart';
import '../entities/flight_seat_entity.dart';
import '../entities/itinerary_entity.dart';

abstract interface class FlightRepository {
  Future<Either<Failure, List<AirportEntity>>> getAirports({
    int page,
    int limit,
  });

  Future<Either<Failure, FlightSearchResultEntity>> searchFlights({
    required int departureAirportId,
    required int arrivalAirportId,
    required String date,
    String tripType,
    String? returnDate,
    int? maxStops,
    required int totalPax,
    int? seatClassId,
    int page,
    int limit,
  });

  Future<Either<Failure, List<FlightSeatEntity>>> getFlightSeats(int flightId);
}
