import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

class StartAiConversation implements UseCase<AiTurnEntity, NoParams> {
  final AiAssistantRepository repository;

  const StartAiConversation(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(NoParams params) {
    return repository.startConversation();
  }
}
