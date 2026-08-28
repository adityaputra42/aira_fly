import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pss_app/features/auth/domain/usecases/user_login.dart';
import 'package:pss_app/features/auth/domain/usecases/user_sign_up.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/usecases/current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin signInUseCase;
  final UserSignUp signOutUseCase;
  final CurrentUser getCurrentUserUseCase;
  AuthBloc({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future _onSignInRequested(SignInRequested event, Emitter emit) async {
    emit(AuthLoading());

    final result = await signInUseCase(
      UserLoginParams(email: event.email, password: event.password),
    );

    result.fold((failure) => emit(AuthError(failure.message)), (user) => emit(Authenticated(user)));
  }

  Future _onCheckAuthStatus(CheckAuthStatus event, Emitter emit) async {
    emit(AuthLoading());

    final result = await getCurrentUserUseCase(NoParams());

    result.fold((failure) => emit(Unauthenticated()), (user) {
      if (user.id != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
