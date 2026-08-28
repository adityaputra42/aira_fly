import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, UpdatedProfileEntity>> updateProfile({
    String? fullName,
    String? email,
  });
}
