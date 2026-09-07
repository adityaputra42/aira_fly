import 'package:flutter/material.dart';

/// Repeats a gentle scale pulse for as long as the widget is mounted.
///
/// This is the odd one out in this folder: everything else in
/// `core/animation` plays once and stops (a widget "appearing"). This
/// one loops forever, so it needs a real [AnimationController] rather
/// than the implicit-animation-widget trick the others use -- hence
/// the explicit dispose. Reach for it for things that are ongoing, not
/// things that just appeared: a "LIVE" badge, an unread-notification
/// dot, a recording indicator. Don't use it on something that should
/// settle down after entering -- that's [FadeIn] or [ScaleIn].
class Pulse extends StatefulWidget {
  const Pulse({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.minScale = 0.94,
    this.maxScale = 1.06,
  });

  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _scale = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
