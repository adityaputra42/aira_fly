/// Animation helper module.
///
/// Two kinds of helpers live here:
///
/// 1. Page transitions -- [PageTransitionType] / [buildPageWithTransition]
///    in `page_transition.dart`, used by `AppRouter`'s route
///    definitions. You generally won't call these directly outside of
///    `app_routes.dart`.
///
/// 2. Widget-appear animations -- [FadeIn], [ScaleIn], [SlideIn],
///    [staggerIn]/[StaggerItem], [Pulse], [BounceTap]. These are for
///    everyday use in screens/widgets: wrap something that just
///    appeared in [FadeIn], wrap a list of cards in [staggerIn], wrap
///    a custom tappable widget in [BounceTap].
///
/// Import this one file to get all of them:
/// ```dart
/// import 'package:pss_app/core/animation/animations.dart';
/// ```
library;

export 'app_animation_config.dart';
export 'bounce_tap.dart';
export 'fade_in.dart';
export 'page_transition.dart';
export 'pulse.dart';
export 'scale_in.dart';
export 'slide_in.dart';
export 'stagger_in.dart';
