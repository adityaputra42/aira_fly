import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/ticket_entity.dart';

abstract interface class TicketRepository {
  /// Checks a passenger in for one segment given their ticket number.
  /// Works self-service (no login required) or agent-assisted (if a
  /// bearer token is present, it's recorded as checked_in_by).
  Future<Either<Failure, CheckInResultEntity>> checkIn({
    required String ticketNumber,
    int? baggageCount,
    String? baggageWeightKg,
  });

  /// Returns 404 (surfaced as a Failure) if the passenger/segment hasn't
  /// checked in yet -- that's the expected way to detect "not checked in".
  Future<Either<Failure, BoardingPassEntity>> getBoardingPass({
    required int passengerId,
    required int segmentId,
  });
}
