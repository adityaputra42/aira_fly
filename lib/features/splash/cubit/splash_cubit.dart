// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../core/utils/pref_helper.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final PrefHelper pref;
  SplashCubit({required this.pref}) : super(SplashInitial());

  Future<void> initApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final bool isFirstTime = pref.isFirstInstall;

    if (isFirstTime == true) {
      emit(SplashToOnboarding());
    } else {
      emit(SplashToHome());
    }
  }
}
