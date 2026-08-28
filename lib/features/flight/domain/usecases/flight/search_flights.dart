import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/itinerary_entity.dart';
import '../../repository/flight_repository.dart';

class SearchFlights implements UseCase<FlightSearchResultEntity, SearchFlightsParams> {
  final FlightRepository flightRepository;

  const SearchFlights(this.flightRepository);

  @override
  Future<Either<Failure, FlightSearchResultEntity>> call(SearchFlightsParams params) {
    return flightRepository.searchFlights(
      departureAirportId: params.departureAirportId,
      arrivalAirportId: params.arrivalAirportId,
      date: params.date,
      tripType: params.tripType,
      returnDate: params.returnDate,
      maxStops: params.maxStops,
      totalPax: params.totalPax,
      seatClassId: params.seatClassId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchFlightsParams {
  final int departureAirportId;
  final int arrivalAirportId;
  final String date; // YYYY-MM-DD
  final String tripType; // one_way | round_trip
  final String? returnDate; // YYYY-MM-DD, required if tripType == round_trip
  final int? maxStops; // 0 = direct only, 1 = allow one connection (default)
  final int totalPax;
  final int? seatClassId;
  final int page;
  final int limit;

  const SearchFlightsParams({
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
}
