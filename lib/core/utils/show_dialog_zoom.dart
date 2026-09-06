import 'package:flutter/material.dart';

Future<T?> showZoomDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  Color barrierColor = const Color(0x80000000),
  Duration duration = const Duration(milliseconds: 500),
}) {
  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dialog',
    barrierColor: barrierColor,
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Material(type: MaterialType.transparency, child: child);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
