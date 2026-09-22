import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/pnr_entity.dart';
import '../../repository/booking_repository.dart';

/// Guest (signed-out) booking lookup by code. See the long warning on
/// BookingRepository.getPnrByBookingCode before wiring this into any UI
/// that assumes it's safe against being used to look up someone else's
/// booking -- as of 2026-09-18 the backend does not actually enforce
/// that.
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
