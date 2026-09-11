import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/features/auth/domain/usecases/user_login.dart';
import 'package:pss_app/features/auth/domain/usecases/user_sign_up.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin signInUseCase;
  final UserSignUp signOutUseCase;
  final CurrentUser getCurrentUserUseCase;
  final UserCubit appUserCubit;
  AuthBloc({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.appUserCubit,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
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

  Future _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
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
