import 'package:flutter/material.dart';

class CardGeneral extends StatelessWidget {
  const CardGeneral({
    super.key,
    this.child,
    this.background,
    this.margin,
    this.padding,
    this.border,
    this.radius,
    this.height,
    this.width,
  });
  final Widget? child;
  final Color? background;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? radius;
  final Border? border;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(radius ?? 8),
          color: background ?? Theme.of(context).cardColor),
      child: child,
    );
  }
}
