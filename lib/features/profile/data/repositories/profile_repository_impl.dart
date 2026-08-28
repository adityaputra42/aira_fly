import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const ProfileRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getProfile();
      if (response == null) {
        return left(Failure('Failed to load profile'));
      }

      return right(ProfileModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UpdatedProfileEntity>> updateProfile({
    String? fullName,
    String? email,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.updateProfile(fullName: fullName, email: email);
      if (response == null) {
        return left(Failure('Failed to update profile'));
      }

      return right(UpdatedProfileModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
