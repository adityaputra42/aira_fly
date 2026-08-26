import 'package:fpdart/fpdart.dart';
import 'package:pss_app/features/auth/data/models/user_model.dart';
import 'package:pss_app/features/auth/domain/entities/user_entities.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl(this.remoteDataSource, this.localDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
        username: username,
      );
      if (response == null) {
        return left(Failure('Register Failed'));
      }

      var loginResponse = loginResponseModelFromJson(response.data);

      localDataSource.saveAccessToken(loginResponse.accessToken ?? "");

      localDataSource.saveRefreshToken(loginResponse.refreshToken ?? "");

      return right(loginResponse.user ?? UserModel());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getCurrentUserData();
      if (response == null) {
        return left(Failure('Register Failed'));
      }
      var user = userModelFromJson(response.data);

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.login(email: email, password: password);

      if (response == null) {
        return left(Failure('Register Failed'));
      }

      var loginResponse = loginResponseModelFromJson(response.data);

      localDataSource.saveAccessToken(loginResponse.accessToken ?? "");

      localDataSource.saveRefreshToken(loginResponse.refreshToken ?? "");

      return right(loginResponse.user ?? UserModel());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
