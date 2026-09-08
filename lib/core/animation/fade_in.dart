import 'package:flutter/material.dart';

import 'app_animation_config.dart';
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

  final Duration delay;
  final Curve curve;

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
