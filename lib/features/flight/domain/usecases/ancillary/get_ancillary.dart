import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/ancillary_entity.dart';
import '../../repository/ancillary_repository.dart';

class GetAncillary implements UseCase<AncillaryItemEntity, GetAncillaryParams> {
  final AncillaryRepository ancillaryRepository;

  const GetAncillary(this.ancillaryRepository);

  @override
  Future<Either<Failure, AncillaryItemEntity>> call(GetAncillaryParams params) {
    return ancillaryRepository.getAncillary(params.id);
  }
}

class GetAncillaryParams {
  final int id;

  const GetAncillaryParams({required this.id});
}
