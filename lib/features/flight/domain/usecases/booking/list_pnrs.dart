import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/pnr_entity.dart';
import '../../repository/booking_repository.dart';

/// NOTE: backed by an admin-only endpoint (`booking:pnr:view` permission).
class ListPnrs implements UseCase<List<PnrSummaryEntity>, ListPnrsParams> {
  final BookingRepository bookingRepository;

  const ListPnrs(this.bookingRepository);

  @override
  Future<Either<Failure, List<PnrSummaryEntity>>> call(ListPnrsParams params) {
    return bookingRepository.listPnrs(
      page: params.page,
      limit: params.limit,
      status: params.status,
    );
  }
}

class ListPnrsParams {
  final int page;
  final int limit;
  final String? status;

  const ListPnrsParams({this.page = 1, this.limit = 10, this.status});
}
