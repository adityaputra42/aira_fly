import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/ancillary_entity.dart';
import '../../repository/ancillary_repository.dart';

class ListAncillariesByFlight
    implements UseCase<List<AncillaryItemEntity>, ListAncillariesByFlightParams> {
  final AncillaryRepository ancillaryRepository;

  const ListAncillariesByFlight(this.ancillaryRepository);

  @override
  Future<Either<Failure, List<AncillaryItemEntity>>> call(
    ListAncillariesByFlightParams params,
  ) {
    return ancillaryRepository.listByFlight(params.flightId);
  }
}

class ListAncillariesByFlightParams {
  final int flightId;

  const ListAncillariesByFlightParams({required this.flightId});
}
