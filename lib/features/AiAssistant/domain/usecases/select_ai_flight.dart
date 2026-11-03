import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

class SelectAiFlight implements UseCase<AiTurnEntity, SelectAiFlightParams> {
  final AiAssistantRepository repository;

  const SelectAiFlight(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(SelectAiFlightParams params) {
    return repository.selectFlight(
      id: params.id,
      departureOptionId: params.departureOptionId,
      fareClassId: params.fareClassId,
      returnOptionId: params.returnOptionId,
    );
  }
}

class SelectAiFlightParams {
  final String id;
  final String departureOptionId;
  final int fareClassId;
  final String? returnOptionId;

  const SelectAiFlightParams({
    required this.id,
    required this.departureOptionId,
    required this.fareClassId,
    this.returnOptionId,
  });
}
