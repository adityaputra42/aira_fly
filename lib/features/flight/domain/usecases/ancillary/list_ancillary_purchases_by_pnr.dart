import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/ancillary_entity.dart';
import '../../repository/ancillary_repository.dart';

class ListAncillaryPurchasesByPnr
    implements UseCase<List<BookingAncillaryEntity>, ListAncillaryPurchasesByPnrParams> {
  final AncillaryRepository ancillaryRepository;

  const ListAncillaryPurchasesByPnr(this.ancillaryRepository);

  @override
  Future<Either<Failure, List<BookingAncillaryEntity>>> call(
    ListAncillaryPurchasesByPnrParams params,
  ) {
    return ancillaryRepository.listPurchasesByPnr(params.pnrId);
  }
}

class ListAncillaryPurchasesByPnrParams {
  final int pnrId;

  const ListAncillaryPurchasesByPnrParams({required this.pnrId});
}
