import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

/// Passenger data goes through a FORM, never through chat.
class SubmitAiPassengers implements UseCase<AiTurnEntity, SubmitAiPassengersParams> {
  final AiAssistantRepository repository;

  const SubmitAiPassengers(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(SubmitAiPassengersParams params) {
    return repository.submitPassengers(
      id: params.id,
      contact: params.contact,
      passengers: params.passengers,
    );
  }
}

class SubmitAiPassengersParams {
  final String id;
  final AiContactEntity contact;
  final List<AiPassengerEntity> passengers;

  const SubmitAiPassengersParams({
    required this.id,
    required this.contact,
    required this.passengers,
  });
}
