import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

class SendAiMessage implements UseCase<AiTurnEntity, SendAiMessageParams> {
  final AiAssistantRepository repository;

  const SendAiMessage(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(SendAiMessageParams params) {
    return repository.sendMessage(
      id: params.id,
      message: params.message,
      inputType: params.inputType,
    );
  }
}

class SendAiMessageParams {
  final String id;
  final String message;
  final AiInputType inputType;

  const SendAiMessageParams({
    required this.id,
    required this.message,
    this.inputType = AiInputType.text,
  });
}
