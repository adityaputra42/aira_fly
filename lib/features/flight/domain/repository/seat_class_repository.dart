import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/seat_class_entity.dart';

abstract interface class SeatClassRepository {
  Future<Either<Failure, List<SeatClassEntity>>> getSeatClasses({int page, int limit});
}
