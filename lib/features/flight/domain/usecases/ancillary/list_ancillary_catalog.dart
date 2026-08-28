import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/ancillary_entity.dart';
import '../../repository/ancillary_repository.dart';

class ListAncillaryCatalog
    implements UseCase<List<AncillaryItemEntity>, ListAncillaryCatalogParams> {
  final AncillaryRepository ancillaryRepository;

  const ListAncillaryCatalog(this.ancillaryRepository);

  @override
  Future<Either<Failure, List<AncillaryItemEntity>>> call(ListAncillaryCatalogParams params) {
    return ancillaryRepository.listCatalog(
      categoryId: params.categoryId,
      activeOnly: params.activeOnly,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListAncillaryCatalogParams {
  final int? categoryId;
  final bool activeOnly;
  final int page;
  final int limit;

  const ListAncillaryCatalogParams({
    this.categoryId,
    this.activeOnly = true,
    this.page = 1,
    this.limit = 10,
  });
}
