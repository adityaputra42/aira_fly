import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xff09CDC2);

  static const Color secondaryColor = Color(0xff8AFFF9);
  static const Color grayColor = Color(0xff8E90AD);
  static const Color yellowColor = Color(0xffF7931A);
  static const Color redColor = Color(0xffF25252);
  static const Color secondRedColor = Color(0xffEE9F91);
  static const Color greenColor = Color(0xff33D49D);

  // Ligth Mode
  static const Color bgLight = Color(0xffF6F6FB);
  static const Color cardLight = Color(0xffFFFFFF);
  static const Color lightText1 = Color(0xff25282C);
  static const Color lightText2 = Color(0xffADB1B8);
  static const Color lightText3 = Color(0xffE8EBF1);
  static const Color strokeLight = Color(0xffE2E8F0);
  static const Color lightGrey = Color(0xffF3F5F7);
  static const Color lightGrey2 = Color(0xffD1D4DC);
  static const Color lightGrey3 = Color(0xffF7FAFF);
  static const Color deepBlue = Color(0xff040815);
  static const Color slateBlue = Color(0xff596780);
  static const Color lightCharcoal = Color(0xff404347);
  static const Color paleSky = Color(0xffEDF2F7);
  static const Color dividerLight = Color(0xffF1F4FA);
  static const Color darkGrey = Color(0xff71757A);
  // Dark Mode
  static const Color bgDark = Color(0xff0A0D14);
  static const Color cardDark = Color(0xff14171D);
  static const Color darkText1 = Color(0xffFBFCFF);
  static const Color darkText2 = Color(0xff7E7E81);
  static const Color darkText3 = Color(0xff90A3BF);
  static const Color strokeDark = Color(0xff2D3748);
  static const Color dividerDark = Color(0xff5D636F);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColor.primaryColor, AppColor.secondaryColor],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
  static const LinearGradient errorGradient = LinearGradient(
    colors: [AppColor.redColor, AppColor.secondRedColor],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [AppColor.primaryColor, AppColor.secondaryColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient disableButtonGradient = LinearGradient(
    colors: [
      AppColor.primaryColor.withValues(alpha: 0.5),
      AppColor.secondaryColor.withValues(alpha: 0.5),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashDarkGradient = LinearGradient(
    colors: [AppColor.bgDark, AppColor.cardDark],
    begin: Alignment.centerLeft,
    end: Alignment.topRight,
  );
}
