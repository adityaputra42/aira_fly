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

  /// Micro-interactions: button press feedback, tap scale.
  static const fast = Duration(milliseconds: 150);

  /// Default for most widget-appear animations (fade/slide/scale-in).
  static const normal = Duration(milliseconds: 400);

  /// Page transitions, larger surfaces (bottom sheets, dialogs).
  static const slow = Duration(milliseconds: 600);

  /// Per-item delay step inside a staggered list.
  static const staggerStep = Duration(milliseconds: 60);
}

class AppAnimationCurves {
  const AppAnimationCurves._();

  /// Default curve for anything entering the screen.
  static const entrance = Curves.easeOutCubic;

  /// Default curve for anything leaving the screen.
  static const exit = Curves.easeInCubic;

  /// Symmetric curve, used by page transitions
  /// (kept as its own constant since app_routes.dart already shipped
  /// with this exact curve before this file existed -- changing it
  /// would change the feel of every existing route transition).
  static const pageTransition = Curves.easeInOutCubic;
}
