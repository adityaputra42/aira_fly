import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

class UpdateProfile implements UseCase<UpdatedProfileEntity, UpdateProfileParams> {
  final ProfileRepository profileRepository;

  const UpdateProfile(this.profileRepository);

  @override
  Future<Either<Failure, UpdatedProfileEntity>> call(UpdateProfileParams params) {
    return profileRepository.updateProfile(fullName: params.fullName, email: params.email);
  }
}

class UpdateProfileParams {
  final String? fullName;
  final String? email;

  const UpdateProfileParams({this.fullName, this.email});
}
