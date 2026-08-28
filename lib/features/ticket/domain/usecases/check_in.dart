import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ticket_entity.dart';
import '../repository/ticket_repository.dart';

class CheckIn implements UseCase<CheckInResultEntity, CheckInParams> {
  final TicketRepository ticketRepository;

  const CheckIn(this.ticketRepository);

  @override
  Future<Either<Failure, CheckInResultEntity>> call(CheckInParams params) {
    return ticketRepository.checkIn(
      ticketNumber: params.ticketNumber,
      baggageCount: params.baggageCount,
      baggageWeightKg: params.baggageWeightKg,
    );
  }
}

class CheckInParams {
  final String ticketNumber;
  final int? baggageCount;
  final String? baggageWeightKg; // decimal string, e.g. "15.50"

  const CheckInParams({required this.ticketNumber, this.baggageCount, this.baggageWeightKg});
}
