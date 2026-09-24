import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/seat_class_entity.dart';
import '../../repository/seat_class_repository.dart';

class GetSeatClasses implements UseCase<List<SeatClassEntity>, GetSeatClassesParams> {
  final SeatClassRepository seatClassRepository;

  const GetSeatClasses(this.seatClassRepository);

  @override
  Future<Either<Failure, List<SeatClassEntity>>> call(GetSeatClassesParams params) {
    return seatClassRepository.getSeatClasses(page: params.page, limit: params.limit);
  }
}

class GetSeatClassesParams {
  final int page;
  final int limit;

  const GetSeatClassesParams({this.page = 1, this.limit = 200});
}
