import 'package:flutter/material.dart';

import 'app_animation_config.dart';
import 'fade_in.dart';

List<Widget> staggerIn(
  List<Widget> children, {
  Duration step = AppAnimationDuration.staggerStep,
  Duration duration = AppAnimationDuration.normal,
  Curve curve = AppAnimationCurves.entrance,
  Offset offsetBegin = const Offset(0, 0.08),

  int maxDelayIndex = 8,
}) {
  return [
    for (final entry in children.asMap().entries)
      FadeIn(
        key: entry.value.key,
        delay: step * (entry.key > maxDelayIndex ? maxDelayIndex : entry.key),
        duration: duration,
        curve: curve,
        offsetBegin: offsetBegin,
        child: entry.value,
      ),
  ];
}

class StaggerItem extends StatelessWidget {
  const StaggerItem({
    super.key,
    required this.index,
    required this.child,
    this.step = AppAnimationDuration.staggerStep,
    this.duration = AppAnimationDuration.normal,
    this.curve = AppAnimationCurves.entrance,
    this.offsetBegin = const Offset(0, 0.08),
    this.maxDelayIndex = 8,
  });

  final int index;
  final Widget child;
  final Duration step;
  final Duration duration;
  final Curve curve;
  final Offset offsetBegin;
  final int maxDelayIndex;

  @override
  Widget build(BuildContext context) {
    final cappedIndex = index > maxDelayIndex ? maxDelayIndex : index;
    return FadeIn(
      delay: step * cappedIndex,
      duration: duration,
      curve: curve,
      offsetBegin: offsetBegin,
      child: child,
    );
  }
}
