import 'package:flutter/material.dart';

import 'app_animation_config.dart';

/// Fades a widget in, optionally sliding it up/in from [offsetBegin] at
/// the same time -- the Flutter equivalent of the web admin's
/// `animate-in fade-in slide-in-from-bottom-4` utility classes.
///
/// This is the animation to reach for by default when a widget needs to
/// "muncul" (appear) on screen -- a card, a section, a whole page body.
/// For a widget re-fading every time its content changes (not just on
/// first appearance), wrap it in [AnimatedSwitcher] instead; this widget
/// only ever plays once, when it's first built.
///
/// ```dart
/// FadeIn(
///   child: FlightCard(flight: flight),
/// )
///
/// // Staggered inside a list -- see stagger_in.dart for a helper that
/// // computes the delay for you.
/// FadeIn(delay: Duration(milliseconds: index * 60), child: item)
/// ```
class FadeIn extends StatefulWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.duration = AppAnimationDuration.normal,
    this.delay = Duration.zero,
    this.curve = AppAnimationCurves.entrance,
    this.offsetBegin = const Offset(0, 0.08),
  });

  final Widget child;
  final Duration duration;

  /// How long to wait before the animation starts. Useful for
  /// staggering multiple widgets so they don't all pop in at once.
  final Duration delay;
  final Curve curve;

  /// Fractional offset (relative to the child's own size) the widget
  /// slides in from. `Offset(0, 0.08)` (the default) slides up from
  /// just below its final position -- pass `Offset.zero` for a plain
  /// fade with no movement.
  final Offset offsetBegin;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      // Skip the microtask round-trip when there's nothing to wait
      // for -- starting visible-but-animating-in on the very first
      // frame looks identical and avoids an unnecessary rebuild.
      _visible = true;
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.offsetBegin,
      duration: widget.duration,
      curve: widget.curve,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
