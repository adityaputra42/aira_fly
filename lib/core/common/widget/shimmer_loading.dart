import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/theme/theme.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    this.margin,
    this.height,
    this.width = double.infinity,
    this.radius = 8,
  });
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppColor.grayColor,
        highlightColor: AppColor.lightText1,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: AppColor.grayColor,
          ),
        ),
      ),
    );
  }
}

class ShimmerLoadingCircle extends StatelessWidget {
  const ShimmerLoadingCircle({
    super.key,
    this.margin,
    this.height,
    this.width = double.infinity,
  });
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppColor.grayColor,
        highlightColor: AppColor.lightText1,
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.grayColor,
          ),
        ),
      ),
    );
  }
}
