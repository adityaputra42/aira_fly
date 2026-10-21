import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../app/theme/theme.dart';

class TopSnackbarHelper {
  TopSnackbarHelper._();

  static void success(
    BuildContext context, {
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _show(
      context,

      displayDuration: displayDuration,
      snackBar: CustomSnackBar.success(message: message, messagePadding: EdgeInsetsGeometry.symmetric(horizontal: 16,vertical: 8),
        backgroundColor: AppColor.greenColor,
        borderRadius: BorderRadius.circular(8),
        maxLines: 2,
        textStyle: AppFont.medium14.copyWith(color: AppColor.darkText1),
        icon: SizedBox(),),
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _show(
      context,

      displayDuration: displayDuration,
      snackBar: CustomSnackBar.error( messagePadding: EdgeInsetsGeometry.symmetric(horizontal: 16,vertical: 8),
          backgroundColor: AppColor.redColor,
          borderRadius: BorderRadius.circular(8),
          maxLines: 2,
          textStyle: AppFont.medium14.copyWith(color: AppColor.darkText1),
          icon: SizedBox(), message: message),
    );
  }

  static void info(
    BuildContext context, {
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      displayDuration: displayDuration,
      snackBar: CustomSnackBar.info(
        messagePadding: EdgeInsetsGeometry.symmetric(horizontal: 16,vertical: 8),
        backgroundColor: AppColor.yellowColor,
        borderRadius: BorderRadius.circular(8),
        maxLines: 2,
        textStyle: AppFont.medium14.copyWith(color: AppColor.darkText1),
        icon: SizedBox(),
        message: message,
      ),
    );
  }

  static void _show(
    BuildContext context, {
    required Widget snackBar,
    required Duration displayDuration,
  }) {
    if (!context.mounted) return;

    showTopSnackBar(
      Overlay.of(context),
      snackBar,
      displayDuration: displayDuration,
      animationDuration: const Duration(milliseconds: 500),
      reverseAnimationDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );
  }
}
