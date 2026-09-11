import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/fare_class_entity.dart';
import '../../repository/fare_class_repository.dart';

class GetFareClasses implements UseCase<List<FareClassEntity>, GetFareClassesParams> {
  final FareClassRepository fareClassRepository;

  const GetFareClasses(this.fareClassRepository);

  @override
  Future<Either<Failure, List<FareClassEntity>>> call(GetFareClassesParams params) {
    return fareClassRepository.getFareClasses(page: params.page, limit: params.limit);
  }
}

class GetFareClassesParams {
  final int page;
  final int limit;

  const GetFareClassesParams({this.page = 1, this.limit = 200});
}
