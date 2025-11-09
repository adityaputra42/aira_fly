import 'package:flutter/material.dart';

import '../../../config/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.title,
    this.height = 48,
    this.width = double.infinity,
    this.margin = EdgeInsets.zero,
    this.pading = EdgeInsets.zero,
    this.borderColor,
    this.textColor,
    this.bgColor,
    this.loading = false,
    this.disable = false,
    this.isgradient = false,
    this.onPressed,
  });

  final String title;
  final double width;
  final EdgeInsets margin;
  final EdgeInsets pading;
  final double height;
  final Color? borderColor;
  final Color? bgColor;
  final Color? textColor;
  final bool loading;
  final bool disable;
  final bool isgradient;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    //
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: pading,
          elevation: 0,
          side: BorderSide(
            width: 1,
            color: borderColor ?? Theme.of(context).canvasColor,
          ),
          backgroundColor: bgColor ?? Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: loading || disable ? () {} : onPressed,
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ),
              )
            : Text(
                title,
                textAlign: TextAlign.center,
                style: AppFont.medium14.copyWith(
                  color: disable
                      ? Theme.of(context).hintColor
                      : (textColor ?? Theme.of(context).colorScheme.onSurface),
                ),
              ),
      ),
    );
  }
}
