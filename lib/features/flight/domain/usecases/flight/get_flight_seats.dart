import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/flight_seat_entity.dart';
import '../../repository/flight_repository.dart';

class GetFlightSeats implements UseCase<List<FlightSeatEntity>, GetFlightSeatsParams> {
  final FlightRepository flightRepository;

  const GetFlightSeats(this.flightRepository);

  @override
  Future<Either<Failure, List<FlightSeatEntity>>> call(GetFlightSeatsParams params) {
    return flightRepository.getFlightSeats(params.flightId);
  }
}

class GetFlightSeatsParams {
  final int flightId;

  const GetFlightSeatsParams({required this.flightId});
}
