import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/ai_assistant_entity.dart';

/// Every method returns [AiFailure] (a [Failure]) on error so the UI can
/// react to retry / fallback / conversation-gone, not just show a string.
abstract interface class AiAssistantRepository {
  Future<Either<Failure, AiTurnEntity>> startConversation();

  /// `right(null)` when there is nothing to resume (server answers 404).
  Future<Either<Failure, AiConversationEntity?>> getActiveConversation();

  Future<Either<Failure, AiConversationEntity>> getConversation(String id);

  Future<Either<Failure, AiTurnEntity>> sendMessage({
    required String id,
    required String message,
    AiInputType inputType = AiInputType.text,
  });

  Future<Either<Failure, AiTurnEntity>> selectFlight({
    required String id,
    required String departureOptionId,
    required int fareClassId,
    String? returnOptionId,
  });

  Future<Either<Failure, AiTurnEntity>> submitPassengers({
    required String id,
    required AiContactEntity contact,
    required List<AiPassengerEntity> passengers,
  });

  Future<Either<Failure, AiTurnEntity>> confirmBooking({
    required String id,
    required String summaryHash,
  });

  Future<Either<Failure, AiTurnEntity>> confirmPayment({
    required String id,
    required String summaryHash,
    required String channel,
  });

  Future<Either<Failure, AiTurnEntity>> refreshPayment(String id);

  /// Only valid before a payment exists (otherwise 409).
  Future<Either<Failure, AiTurnEntity>> cancelConversation(String id);
}
