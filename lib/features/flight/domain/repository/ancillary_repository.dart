import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/ancillary_entity.dart';

abstract interface class AncillaryRepository {
  Future<Either<Failure, List<AncillaryCategoryEntity>>> listCategories({
    int page,
    int limit,
  });

  Future<Either<Failure, List<AncillaryItemEntity>>> listCatalog({
    int? categoryId,
    bool activeOnly,
    int page,
    int limit,
  });

  Future<Either<Failure, AncillaryItemEntity>> getAncillary(int id);

  Future<Either<Failure, List<AncillaryItemEntity>>> listByFlight(int flightId);

  Future<Either<Failure, BookingAncillaryEntity>> purchase({
    required int pnrId,
    int? passengerId,
    int? segmentId,
    required int ancillaryId,
    int? flightId,
    required int quantity,
  });

  Future<Either<Failure, BookingAncillaryEntity>> cancelPurchase(int id);

  Future<Either<Failure, List<BookingAncillaryEntity>>> listPurchasesByPnr(int pnrId);
}
