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
    return flightRepository.getFlightSeats(flightId:  params.flightId,seatClassId: params.seatClassId);
  }
}

class GetFlightSeatsParams {
  final int flightId;
  final int? seatClassId;

  const GetFlightSeatsParams({required this.flightId, this.seatClassId});
}
