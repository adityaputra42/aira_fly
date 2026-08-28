import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

class GetProfile implements UseCase<ProfileEntity, NoParams> {
  final ProfileRepository profileRepository;

  const GetProfile(this.profileRepository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) {
    return profileRepository.getProfile();
  }
}
