import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/ancillary_entity.dart';
import '../../repository/ancillary_repository.dart';

class ListAncillaryCategories
    implements UseCase<List<AncillaryCategoryEntity>, ListAncillaryCategoriesParams> {
  final AncillaryRepository ancillaryRepository;

  const ListAncillaryCategories(this.ancillaryRepository);

  @override
  Future<Either<Failure, List<AncillaryCategoryEntity>>> call(
    ListAncillaryCategoriesParams params,
  ) {
    return ancillaryRepository.listCategories(page: params.page, limit: params.limit);
  }
}

class ListAncillaryCategoriesParams {
  final int page;
  final int limit;

  const ListAncillaryCategoriesParams({this.page = 1, this.limit = 10});
}
