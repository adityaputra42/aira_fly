import 'package:flutter/material.dart';

import 'app_animation_config.dart';

/// *inside* an already-visible surface.
class ScaleIn extends StatefulWidget {
  const ScaleIn({
    super.key,
    required this.child,
    this.duration = AppAnimationDuration.normal,
    this.delay = Duration.zero,
    this.curve = AppAnimationCurves.entrance,
    this.beginScale = 0.92,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  final double beginScale;

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> {
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
    return AnimatedScale(
      scale: _visible ? 1 : widget.beginScale,
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
