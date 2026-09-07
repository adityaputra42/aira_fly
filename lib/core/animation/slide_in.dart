import 'package:flutter/material.dart';

import 'app_animation_config.dart';

/// Direction a [SlideIn] enters from.
enum SlideInDirection { fromTop, fromBottom, fromLeft, fromRight }

/// Slides a widget in from off its final position, without fading it.
///
/// Use this over [FadeIn] when you specifically want directional
/// movement without an opacity change -- e.g. a filter panel sliding
/// down from the top, a snackbar-like banner sliding up from the
/// bottom. If you want both fade and slide, [FadeIn] already does both
/// and is the better default for most "this widget just appeared" cases.
class SlideIn extends StatefulWidget {
  const SlideIn({
    super.key,
    required this.child,
    this.direction = SlideInDirection.fromBottom,
    this.duration = AppAnimationDuration.normal,
    this.delay = Duration.zero,
    this.curve = AppAnimationCurves.entrance,
    this.distance = 0.15,
  });

  final Widget child;
  final SlideInDirection direction;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  /// How far the widget travels, as a fraction of its own size.
  final double distance;

  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _visible = true;
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  Offset get _beginOffset {
    switch (widget.direction) {
      case SlideInDirection.fromTop:
        return Offset(0, -widget.distance);
      case SlideInDirection.fromBottom:
        return Offset(0, widget.distance);
      case SlideInDirection.fromLeft:
        return Offset(-widget.distance, 0);
      case SlideInDirection.fromRight:
        return Offset(widget.distance, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : _beginOffset,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
