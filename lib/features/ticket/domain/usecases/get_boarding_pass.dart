import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ticket_entity.dart';
import '../repository/ticket_repository.dart';

class GetBoardingPass implements UseCase<BoardingPassEntity, GetBoardingPassParams> {
  final TicketRepository ticketRepository;

  const GetBoardingPass(this.ticketRepository);

  @override
  Future<Either<Failure, BoardingPassEntity>> call(GetBoardingPassParams params) {
    return ticketRepository.getBoardingPass(
      passengerId: params.passengerId,
      segmentId: params.segmentId,
    );
  }
}

class GetBoardingPassParams {
  final int passengerId;
  final int segmentId;

  const GetBoardingPassParams({required this.passengerId, required this.segmentId});
}
