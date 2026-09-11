import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/fare_class_entity.dart';

abstract interface class FareClassRepository {
  Future<Either<Failure, List<FareClassEntity>>> getFareClasses({
    int page,
    int limit,
  });
}
