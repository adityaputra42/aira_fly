import 'package:flutter/material.dart';

import 'app_animation_config.dart';

/// Scales a widget up from [beginScale] while fading it in -- good for
/// things that should feel like they "pop" into place: a success icon,
/// a badge, a card inside a modal, a bottom-sheet's content.
///
/// For the dialog/bottom-sheet TRANSITION itself (the container sliding
/// or fading onto the screen), use [showZoomDialog] in
/// `show_dialog_zoom.dart` -- this widget is for content appearing
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

  /// Starting scale, 0-1. Closer to 1 reads as a subtle pop; closer to
  /// 0 reads as a more dramatic zoom-in.
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
