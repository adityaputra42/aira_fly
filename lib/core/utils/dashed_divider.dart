import 'package:flutter/material.dart';
import 'package:pss_app/core/theme/theme.dart';

Widget generateDashedDivider(double width, {Color? dashColor}) {
  int n = width ~/ 5;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      n,
      (index) => (index % 2 == 0)
          ? Container(height: 2, width: width / n, color: dashColor ?? AppColor.grayColor)
          : SizedBox(width: width / n),
    ),
  );
}
