import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/main/ui/screen/main_screen.dart';
import '../../features/splash/ui/splash_screen.dart';
import '../../features/auth/presentation/screen/sign_in_screen.dart';
import '../../features/auth/presentation/screen/sign_up_screen.dart';
import '../../features/onboarding/ui/screen/onboarding_screen.dart';
import 'route_names.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const SplashScreen(),
          transition: PageTransitionType.fade,
        ),
      ),
      GoRoute(
        path: '/${RouteNames.onboarding}',
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transition: PageTransitionType.sharedAxisHorizontal,
        ),
      ),
      GoRoute(
        path: '/${RouteNames.main}',
        name: RouteNames.main,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const MainScreen(),
          transition: PageTransitionType.fadeThrough,
        ),
      ),
      GoRoute(
        path: '/${RouteNames.signin}',
        name: RouteNames.signin,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const SignInScreen(),
          transition: PageTransitionType.sharedAxisVertical,
        ),
        routes: [
          GoRoute(
            path: RouteNames.signup,
            name: RouteNames.signup,
            pageBuilder: (context, state) => buildPageWithTransition(
              key: state.pageKey,
              child: const SignUpScreen(),
              transition: PageTransitionType.fadeScale,
            ),
          ),
        ],
      ),
    ],
  );
}

enum PageTransitionType {
  fade,
  fadeScale,
  fadeThrough,
  sharedAxisHorizontal,
  sharedAxisVertical,
  sharedAxisScaled,
}

CustomTransitionPage buildPageWithTransition({
  required Widget child,
  required LocalKey key,
  PageTransitionType transition = PageTransitionType.fade,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 800),
    reverseTransitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transition) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);

        case PageTransitionType.fadeScale:
          return FadeScaleTransition(animation: animation, child: child);

        case PageTransitionType.fadeThrough:
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );

        case PageTransitionType.sharedAxisHorizontal:
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );

        case PageTransitionType.sharedAxisVertical:
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            child: child,
          );

        case PageTransitionType.sharedAxisScaled:
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
      }
    },
  );
}
