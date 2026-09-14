import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/init_dependencies.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../app/routes/route_names.dart';
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
              context.pushReplacementNamed(RouteNames.main);
            } else if (state is SplashToHome) {
              context.pushReplacementNamed(RouteNames.main);
            }
          },
          child: Scaffold(
            backgroundColor: AppColor.primaryColor,
            body: Stack(
              children: [
                Image.asset(
                  AppImages.bg,
                  width: context.w(1),
                  height: context.h(1),
                  fit: BoxFit.cover,
                ),
                ZoomIn(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(seconds: 2),
                  child: Center(child: Image.asset(AppImages.whiteLogo, width: context.w(0.35))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
