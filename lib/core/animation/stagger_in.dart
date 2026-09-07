import 'package:flutter/material.dart';

import 'app_animation_config.dart';
import 'fade_in.dart';

/// Wraps each widget in [children] with a [FadeIn] whose delay
/// increases by [step] per item, so a list appears one item after
/// another instead of all at once.
///
/// This returns a `List<Widget>`, not a layout widget -- it doesn't
/// assume Column vs. ListView vs. Wrap. Drop the result straight into
/// whichever layout you're already using:
///
/// ```dart
/// Column(
///   children: staggerIn(flightResults.map((f) => FlightCard(f)).toList()),
/// )
///
/// ListView(
///   children: staggerIn(sections),
/// )
/// ```
///
/// For a `ListView.builder`/`SliverList` with dynamic or very long
/// data, don't stagger every item -- capping the perceived delay
/// (see [maxDelayIndex]) keeps item #40 from waiting 2+ seconds just
/// to fade in.
List<Widget> staggerIn(
  List<Widget> children, {
  Duration step = AppAnimationDuration.staggerStep,
  Duration duration = AppAnimationDuration.normal,
  Curve curve = AppAnimationCurves.entrance,
  Offset offsetBegin = const Offset(0, 0.08),

  /// Items beyond this index all animate with the same delay as this
  /// index, instead of continuing to stack up. Defaults to 8 (roughly
  /// what fits on one screen) -- item 30 in a long list shouldn't make
  /// the user wait for its turn.
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

/// Same idea as [staggerIn], for a single item when you already know
/// its index (e.g. inside `ListView.builder`'s `itemBuilder`) and
/// don't have the full list of widgets on hand to pass to [staggerIn].
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
