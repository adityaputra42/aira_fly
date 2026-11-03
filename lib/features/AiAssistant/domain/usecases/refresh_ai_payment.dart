import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

class RefreshAiPayment implements UseCase<AiTurnEntity, RefreshAiPaymentParams> {
  final AiAssistantRepository repository;

  const RefreshAiPayment(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(RefreshAiPaymentParams params) {
    return repository.refreshPayment(params.id);
  }
}

class RefreshAiPaymentParams {
  final String id;

  const RefreshAiPaymentParams({required this.id});
}
