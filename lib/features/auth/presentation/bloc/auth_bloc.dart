import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/core/utils/push_device_info.dart';
import 'package:pss_app/features/auth/domain/usecases/user_login.dart';
import 'package:pss_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:pss_app/features/notifications/domain/usecases/register_device.dart';
import 'package:pss_app/features/notifications/domain/usecases/unregister_device.dart';
import 'package:pss_app/features/notifications/presentations/bloc/notification_bloc.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../notifications/presentations/utils/notification_helper.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../domain/usecases/current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin signInUseCase;
  final UserSignUp signUpUseCase;
  final CurrentUser getCurrentUserUseCase;
  final UserCubit appUserCubit;
  final AuthLocalDataSource authLocalDataSource;

  final RegisterDevice registerDeviceUseCase;
  final UnregisterDevice unregisterDeviceUseCase;
  final NotificationHelper notificationHelper;
  final NotificationBloc notificationBloc;

  String? _registeredFcmToken;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.getCurrentUserUseCase,
    required this.appUserCubit,
    required this.authLocalDataSource,
    required this.registerDeviceUseCase,
    required this.unregisterDeviceUseCase,
    required this.notificationHelper,
    required this.notificationBloc,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
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

  Future _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await _unregisterPush();

    await authLocalDataSource.clearTokens();
    notificationBloc.add(const NotificationReset());
    emit(AuthInitial());
    appUserCubit.reset();
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

    unawaited(_registerPush());
    notificationBloc.add(const NotificationRefreshed());
  }

  Future<void> _registerPush() async {
    try {
      _registeredFcmToken = null;

      await notificationHelper.initialize(onTokenChanged: _registerToken);

      final token = await notificationHelper.getFCMToken();
      if (token != null && token.isNotEmpty) await _registerToken(token);
    } catch (e, st) {
      log('Register push failed: $e', stackTrace: st);
    }
  }

  Future<void> _registerToken(String token) async {
    final access = await authLocalDataSource.getAccessToken();
    if (access == null || access.isEmpty) return;
    if (token == _registeredFcmToken) return;

    final info = await getPushDeviceInfo();
    final result = await registerDeviceUseCase(
      RegisterDeviceParam(
        fcmToken: token,
        deviceId: info.deviceId,
        appVersion: info.appVersion,
        platform: info.platform,
      ),
    );

    result.fold(
      (f) => log('Register device failed: ${f.message}'),
      (_) => _registeredFcmToken = token,
    );
  }

  Future<void> _unregisterPush() async {
    final token = _registeredFcmToken;
    if (token == null) return;

    try {
      final result = await unregisterDeviceUseCase(UnregisterDeviceParam(fcmToken: token))
          .timeout(const Duration(seconds: 5));

      result.fold(
        (f) => log('Unregister device failed: ${f.message}'),
        (_) => _registeredFcmToken = null,
      );
    } catch (e) {
      log('Unregister device error: $e');
    }
  }
}
