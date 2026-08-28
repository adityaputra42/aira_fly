import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/ancillary_entity.dart';
import '../../repository/ancillary_repository.dart';

/// Purchases at the ancillary's CURRENT price. Does NOT charge the
/// customer and does NOT update the PNR's total_amount by itself --
/// settle payment through the payment feature separately.
class PurchaseAncillary implements UseCase<BookingAncillaryEntity, PurchaseAncillaryParams> {
  final AncillaryRepository ancillaryRepository;

  const PurchaseAncillary(this.ancillaryRepository);

  @override
  Future<Either<Failure, BookingAncillaryEntity>> call(PurchaseAncillaryParams params) {
    return ancillaryRepository.purchase(
      pnrId: params.pnrId,
      passengerId: params.passengerId,
      segmentId: params.segmentId,
      ancillaryId: params.ancillaryId,
      flightId: params.flightId,
      quantity: params.quantity,
    );
  }
}

class PurchaseAncillaryParams {
  final int pnrId;
  final int? passengerId;
  final int? segmentId;
  final int ancillaryId;

  /// Set this to enforce/consume the flight's ancillary whitelist
  /// (SetInventory). Omit only for PNR-level ancillaries with no flight
  /// scope (e.g. a general service fee).
  final int? flightId;
  final int quantity;

  const PurchaseAncillaryParams({
    required this.pnrId,
    this.passengerId,
    this.segmentId,
    required this.ancillaryId,
    this.flightId,
    required this.quantity,
  });
}
