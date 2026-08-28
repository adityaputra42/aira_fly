import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repository/booking_repository.dart';

class CancelPnr implements UseCase<void, CancelPnrParams> {
  final BookingRepository bookingRepository;

  const CancelPnr(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(CancelPnrParams params) {
    return bookingRepository.cancelPnr(params.id);
  }
}

class CancelPnrParams {
  final int id;

  const CancelPnrParams({required this.id});
}
