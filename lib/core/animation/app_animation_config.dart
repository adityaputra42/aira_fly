/// Shared timing/easing constants for every animation helper in this
/// folder (and anywhere else that wants consistency with them).
///
/// Before this file, duration/curve values were hand-picked per call
/// site -- `app_routes.dart` used 600-800ms with `easeInOutCubic`,
/// `show_dialog_zoom.dart` used 500ms with `easeOutCubic`, and nothing
/// else in the app had an opinion. That's fine for two call sites; it
/// stops being fine once every screen starts wrapping widgets in
/// entrance animations. Pick a value from here rather than typing a
/// new magic number -- if the app's motion needs to change later,
/// it changes in one place.
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
