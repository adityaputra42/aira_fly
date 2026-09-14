import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pss_app/core/constants/environment.dart';

import '../core/common/cubit/theme_cubit.dart';
import 'routes/app_routes.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: Environment.getAppEnv() == "dev",
          title: "Aira Fly",
          theme: Styles.themeData(!isDarkMode, context),
          builder: (context, child) {
            return GlobalLoaderOverlay(
              overlayColor: AppColor.primaryColor.withValues(alpha: 0.25),
              overlayWidgetBuilder: (progress) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
                  child: Center(child: CircularProgressIndicator(color: AppColor.secondaryColor)),
                );
              },
              child: child ?? SizedBox(),
            );
          },
        );
      },
    );
  }
}
