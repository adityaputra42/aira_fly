import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/config/di/init_dependencies.dart';
import 'package:pss_app/config/theme/theme.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../config/routes/route_names.dart';
import '../cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<SplashCubit>()..initApp(),
      child: _buiildWidget(),
    );
  }

  Builder _buiildWidget() {
    return Builder(
      builder: (context) {
        return BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashToOnboarding) {
              context.pushReplacementNamed(RouteNames.signin);
            } else if (state is SplashToHome) {
              context.pushReplacementNamed(RouteNames.main);
            }
          },
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.logo, width: context.w(0.4)),
                  height(12),
                  Text(
                    "Aira Fly",
                    style: AppFont.semibold18.copyWith(
                      color: AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
