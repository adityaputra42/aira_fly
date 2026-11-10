import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

class ConfirmAiBooking implements UseCase<AiTurnEntity, ConfirmAiBookingParams> {
  final AiAssistantRepository repository;

  const ConfirmAiBooking(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(ConfirmAiBookingParams params) {
    return repository.confirmBooking(id: params.id, summaryHash: params.summaryHash);
  }
}

class ConfirmAiBookingParams {
  final String id;
  final String summaryHash;

  const ConfirmAiBookingParams({required this.id, required this.summaryHash});
}
