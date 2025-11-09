import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension MediaQueryExtension on BuildContext {
  double h(double value) => mediaQuery.size.height * value;
  double w(double value) => mediaQuery.size.width * value;
}

extension SizedboxExtension on Widget {
  Widget width(double w) => SizedBox(
        width: w,
      );

  Widget height(double h) => SizedBox(
        height: h,
      );
}
