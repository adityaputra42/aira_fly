import 'package:flutter/material.dart';

import 'app_animation_config.dart';

/// Wraps [child] so it shrinks slightly on press and springs back on
/// release -- tactile feedback for anything tappable that isn't
/// already a Material button with its own ink/ripple feedback (a
/// custom card, an icon, a whole list tile you built from scratch).
///
/// This is a gesture + feedback wrapper, not a Material button
/// replacement -- it has no ripple, no disabled styling, no loading
/// state. If you need those, use [ButtonLoading]/`primary_button.dart`
/// /`secondary_button.dart` in `core/common/widget` instead. Reach for
/// this specifically when you want a plain custom widget to feel
/// pressable.
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

  /// Scale while pressed, 0-1. Smaller = more pronounced squash.
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
