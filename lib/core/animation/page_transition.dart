import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_animation_config.dart';

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
  final isAndroid = Platform.isAndroid;
  final duration = isAndroid
      ? const Duration(milliseconds: 800)
      : AppAnimationDuration.slow;

  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: Duration(
      milliseconds: (duration.inMilliseconds * 0.75).round(),
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: AppAnimationCurves.pageTransition,
      );

      final curvedSecondaryAnimation = CurvedAnimation(
        parent: secondaryAnimation,
        curve: AppAnimationCurves.pageTransition,
      );

      switch (transition) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: curvedAnimation, child: child);

        case PageTransitionType.fadeScale:
          return FadeScaleTransition(animation: curvedAnimation, child: child);

        case PageTransitionType.fadeThrough:
          return FadeThroughTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            fillColor: Colors.transparent,
            child: child,
          );

        case PageTransitionType.sharedAxisHorizontal:
          return SharedAxisTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          );

        case PageTransitionType.sharedAxisVertical:
          return SharedAxisTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: Colors.transparent,
            child: child,
          );

        case PageTransitionType.sharedAxisScaled:
          return SharedAxisTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            fillColor: Colors.transparent,
            child: child,
          );
      }
    },
  );
}
