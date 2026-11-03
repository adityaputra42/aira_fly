import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_assistant_entity.dart';
import '../repository/ai_assistant_repository.dart';

/// Creates the DOKU virtual account. Status stays PENDING until the webhook.
class ConfirmAiPayment implements UseCase<AiTurnEntity, ConfirmAiPaymentParams> {
  final AiAssistantRepository repository;

  const ConfirmAiPayment(this.repository);

  @override
  Future<Either<Failure, AiTurnEntity>> call(ConfirmAiPaymentParams params) {
    return repository.confirmPayment(
      id: params.id,
      summaryHash: params.summaryHash,
      channel: params.channel,
    );
  }
}

class ConfirmAiPaymentParams {
  final String id;
  final String summaryHash;
  final String channel;

  const ConfirmAiPaymentParams({
    required this.id,
    required this.summaryHash,
    required this.channel,
  });
}
