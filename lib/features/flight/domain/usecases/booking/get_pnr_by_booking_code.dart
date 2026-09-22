import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/pnr_entity.dart';
import '../../repository/booking_repository.dart';

class GetPnrByBookingCode implements UseCase<PnrDetailEntity, GetPnrByBookingCodeParams> {
  final BookingRepository bookingRepository;

  const GetPnrByBookingCode(this.bookingRepository);

  @override
  Future<Either<Failure, PnrDetailEntity>> call(GetPnrByBookingCodeParams params) {
    return bookingRepository.getPnrByBookingCode(params.bookingCode);
  }
}

class GetPnrByBookingCodeParams {
  final String bookingCode;

  const GetPnrByBookingCodeParams({required this.bookingCode});
}
