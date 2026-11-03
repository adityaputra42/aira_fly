import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

class CancelAiConversation implements UseCase<AiTurnEntity, CancelAiConversationParams> {
  final AiAssistantRepository repository;

  const CancelAiConversation(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(CancelAiConversationParams params) {
    return repository.cancelConversation(params.id);
  }
}

class CancelAiConversationParams {
  final String id;

  const CancelAiConversationParams({required this.id});
}
