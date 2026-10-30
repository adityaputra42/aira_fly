import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/pnr_entity.dart';
import '../../repository/booking_repository.dart';

class GetPnr implements UseCase<PnrDetailEntity, GetPnrParams> {
  final BookingRepository bookingRepository;

  const GetPnr(this.bookingRepository);

  @override
  Future<Either<Failure, PnrDetailEntity>> call(GetPnrParams params) {
    return bookingRepository.getPnr(params.id);
  }
}

class GetPnrParams {
  final int id;

  const GetPnrParams({required this.id});
}
