import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/pnr_entity.dart';
import '../../repository/booking_repository.dart';

/// Self-service booking history -- login required. Use for the "Ticket
/// History" tab when the user is signed in; use [GetPnrByBookingCode] for
/// the guest (signed-out) flow instead.
class ListMyPnrs implements UseCase<List<PnrSummaryEntity>, ListMyPnrsParams> {
  final BookingRepository bookingRepository;

  const ListMyPnrs(this.bookingRepository);

  @override
  Future<Either<Failure, List<PnrSummaryEntity>>> call(ListMyPnrsParams params) {
    return bookingRepository.listMyPnrs(page: params.page, limit: params.limit, status: params.status);
  }
}

class ListMyPnrsParams {
  final int page;
  final int limit;
  final String? status;

  const ListMyPnrsParams({this.page = 1, this.limit = 10, this.status});
}
