import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/airport_entity.dart';
import '../../repository/flight_repository.dart';

class GetAirports implements UseCase<List<AirportEntity>, GetAirportsParams> {
  final FlightRepository flightRepository;

  const GetAirports(this.flightRepository);

  @override
  Future<Either<Failure, List<AirportEntity>>> call(GetAirportsParams params) {
    return flightRepository.getAirports(page: params.page, limit: params.limit);
  }
}

class GetAirportsParams {
  final int page;
  final int limit;

  const GetAirportsParams({this.page = 1, this.limit = 20});
}
