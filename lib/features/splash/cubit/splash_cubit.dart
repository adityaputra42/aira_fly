import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../core/utils/pref_helper.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required this.authBloc}) : super(SplashInitial());

  final AuthBloc authBloc;

  Future<void> initApp() async {
    final authCheckDone = authBloc.stream.firstWhere(
      (state) => state is Authenticated || state is Unauthenticated,
    );

    authBloc.add(CheckAuthStatus());

    await Future.wait([Future.delayed(const Duration(seconds: 3)), authCheckDone]);

    final bool isFirstTime = PrefHelper.instance.isFirstInstall;

    if (isFirstTime == true) {
      emit(SplashToOnboarding());
    } else {
      emit(SplashToHome());
    }
  }
}
