import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

/// Resumes the newest unfinished conversation; `right(null)` if none.
class GetActiveAiConversation implements UseCase<AiConversationEntity?, NoParams> {
  final AiAssistantRepository repository;

  const GetActiveAiConversation(this.repository);

  @override
  Future<Either<Failure, AiConversationEntity?>> call(NoParams params) {
    return repository.getActiveConversation();
  }
}
