import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

class GetAiConversation implements UseCase<AiConversationEntity, GetAiConversationParams> {
  final AiAssistantRepository repository;

  const GetAiConversation(this.repository);

  @override
  Future<Either<Failure, AiConversationEntity>> call(GetAiConversationParams params) {
    return repository.getConversation(params.id);
  }
}

class GetAiConversationParams {
  final String id;

  const GetAiConversationParams({required this.id});
}
