import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/airport_entity.dart';
import '../../domain/entities/flight_seat_entity.dart';
import '../../domain/entities/itinerary_entity.dart';
import '../../domain/repository/flight_repository.dart';
import '../datasources/flight_remote_data_source.dart';
import '../models/airport_model.dart';
import '../models/flight_seat_model.dart';
import '../models/itinerary_model.dart';

class FlightRepositoryImpl implements FlightRepository {
  final FlightRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const FlightRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, List<AirportEntity>>> getAirports({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getAirports(page: page, limit: limit);
      if (response == null) {
        return left(Failure('Failed to load airports'));
      }

      final list = AirportListModel.fromJson(response.data as Map<String, dynamic>);
      return right(list.items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FlightSearchResultEntity>> searchFlights({
    required int departureAirportId,
    required int arrivalAirportId,
    required String date,
    String tripType = 'one_way',
    String? returnDate,
    int? maxStops,
    required int totalPax,
    int? seatClassId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.searchFlights(
        departureAirportId: departureAirportId,
        arrivalAirportId: arrivalAirportId,
        date: date,
        tripType: tripType,
        returnDate: returnDate,
        maxStops: maxStops,
        totalPax: totalPax,
        seatClassId: seatClassId,
        page: page,
        limit: limit,
      );
      if (response == null) {
        return left(Failure('Failed to search flights'));
      }

      final result = FlightSearchResultModel.fromJson(response.data as Map<String, dynamic>);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FlightSeatEntity>>> getFlightSeats(int flightId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getFlightSeats(flightId);
      if (response == null) {
        return left(Failure('Failed to load flight seats'));
      }

      final seats = (response.data as List)
          .map((e) => FlightSeatModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(seats);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
