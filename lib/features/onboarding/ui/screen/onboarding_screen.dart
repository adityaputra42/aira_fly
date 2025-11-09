import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/init_dependencies.dart';
import '../../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<OnboardingCubit>(),
      child: _buildWidget(),
    );
  }

  Builder _buildWidget() {
    return Builder(
      builder: (context) {
        return Scaffold();
      },
    );
  }
}
