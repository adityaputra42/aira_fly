import 'package:flutter/material.dart';

import 'app_animation_config.dart';
class BounceTap extends StatefulWidget {
  const BounceTap({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.96,
    this.duration = AppAnimationDuration.fast,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;

  final double scaleDown;
  final Duration duration;
  final HitTestBehavior behavior;

  @override
  State<BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<BounceTap> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scaleDown : 1,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
