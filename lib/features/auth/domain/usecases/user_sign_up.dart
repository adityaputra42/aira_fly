import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entities.dart';
import '../repository/auth_repository.dart';

class UserSignUp implements UseCase<UserEntity, UserSignUpParams> {
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UserSignUpParams params) {
    return authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
      username: params.username,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  final String username;

  const UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.username,
  });
}
