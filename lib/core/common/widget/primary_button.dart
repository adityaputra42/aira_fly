import 'package:flutter/material.dart';

import '../../../config/theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.margin = EdgeInsets.zero,
    required this.onPressed,
    this.disable = false,
    this.activeColor = AppColor.primaryColor,
    this.disableColor,
    this.bgColor,
    this.textColor,
    this.useExpanded = false,
    this.child,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.textStyle,
    this.buttonPadding,
    this.height = 42,
  });

  final String title;
  final double width;
  final EdgeInsets margin;
  final EdgeInsets? buttonPadding;
  final double? height;
  final Function() onPressed;
  final Color activeColor;
  final Color? disableColor;
  final Color? bgColor;
  final TextStyle? textStyle;
  final bool disable;
  // final bool loading;

  final Widget? child;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? textColor;
  final bool? useExpanded;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: !disable
            ? (bgColor ?? AppColor.primaryColor)
            : (disableColor ?? Theme.of(context).cardColor),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: disable ? () {} : onPressed,
        child:
            child ??
            Text(
              title,
              style:
                  textStyle ??
                  AppFont.medium14.copyWith(
                    color: disable
                        ? Theme.of(context).hintColor
                        : (textColor ?? AppColor.darkText1),
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }
}
