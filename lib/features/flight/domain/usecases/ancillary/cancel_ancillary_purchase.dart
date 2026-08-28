import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/ancillary_entity.dart';
import '../../repository/ancillary_repository.dart';

class CancelAncillaryPurchase
    implements UseCase<BookingAncillaryEntity, CancelAncillaryPurchaseParams> {
  final AncillaryRepository ancillaryRepository;

  const CancelAncillaryPurchase(this.ancillaryRepository);

  @override
  Future<Either<Failure, BookingAncillaryEntity>> call(CancelAncillaryPurchaseParams params) {
    return ancillaryRepository.cancelPurchase(params.id);
  }
}

class CancelAncillaryPurchaseParams {
  final int id;

  const CancelAncillaryPurchaseParams({required this.id});
}
