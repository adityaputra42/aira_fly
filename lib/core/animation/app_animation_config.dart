library;

import 'package:flutter/animation.dart';

class AppAnimationDuration {
  const AppAnimationDuration._();

  static const fast = Duration(milliseconds: 150);

  static const normal = Duration(milliseconds: 400);

  static const slow = Duration(milliseconds: 600);

  static const staggerStep = Duration(milliseconds: 60);
}

class AppAnimationCurves {
  const AppAnimationCurves._();

  static const entrance = Curves.easeOutCubic;

  static const exit = Curves.easeInCubic;

  static const pageTransition = Curves.easeInOutCubic;
}
