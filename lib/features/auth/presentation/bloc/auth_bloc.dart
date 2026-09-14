import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/features/auth/domain/usecases/user_login.dart';
import 'package:pss_app/features/auth/domain/usecases/user_sign_up.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../domain/usecases/current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin signInUseCase;
  final UserSignUp signUpUseCase;
  final CurrentUser getCurrentUserUseCase;
  final UserCubit appUserCubit;
  final AuthLocalDataSource authLocalDataSource; // <-- baru

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.getCurrentUserUseCase,
    required this.appUserCubit,
    required this.authLocalDataSource, // <-- baru
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signInUseCase(
      UserLoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  Future _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signUpUseCase(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
        username: event.username,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  Future _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null || token.isEmpty) {
      emit(Unauthenticated());
      return;
    }

    emit(AuthLoading());

    final result = await getCurrentUserUseCase(NoParams());

    result.fold((failure) => emit(Unauthenticated()), (user) {
      if (user.id != null) {
        _emitAuthSuccess(user, emit);
      } else {
        emit(Unauthenticated());
      }
    });
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    appUserCubit.updateUser(user);
    emit(Authenticated(user));
  }
}
