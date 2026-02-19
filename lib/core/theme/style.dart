import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_font.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    final colorScheme = ColorScheme(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      primary: AppColor.primaryColor,
      onPrimary: isDarkTheme ? AppColor.darkText1 : AppColor.lightText1,
      secondary: AppColor.secondaryColor,
      onSecondary: isDarkTheme ? AppColor.darkText1 : AppColor.lightText1,
      error: AppColor.redColor,
      onError: isDarkTheme ? AppColor.darkText1 : AppColor.lightText1,
      surface: isDarkTheme ? AppColor.bgDark : AppColor.bgLight,
      onSurface: isDarkTheme ? AppColor.darkText1 : AppColor.lightText1,
      surfaceContainer: isDarkTheme ? AppColor.cardDark : AppColor.cardLight,
      onSurfaceVariant: isDarkTheme ? AppColor.darkText2 : AppColor.lightText2,
      outline: isDarkTheme ? AppColor.strokeDark : AppColor.strokeLight,
      shadow: AppColor.strokeDark,
      inverseSurface: isDarkTheme ? AppColor.darkText1 : AppColor.lightText1,
      onInverseSurface: isDarkTheme ? AppColor.bgDark : AppColor.bgLight,
      inversePrimary: AppColor.primaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: "Poppins",

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
        ),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceContainer,
        headerBackgroundColor: isDarkTheme
            ? AppColor.cardDark
            : AppColor.cardLight,
        headerForegroundColor: colorScheme.onSurface,
        yearStyle: AppFont.medium12.copyWith(color: colorScheme.onSurface),
        dayStyle: AppFont.medium12.copyWith(color: colorScheme.onSurface),
        weekdayStyle: AppFont.medium12.copyWith(color: colorScheme.onSurface),
        dividerColor: colorScheme.outline,
        dayForegroundColor: WidgetStateColor.resolveWith((states) {
          return colorScheme.onSurface;
        }),
        dayOverlayColor: WidgetStateColor.resolveWith((states) {
          return colorScheme.primary.withValues(alpha: 0.2);
        }),
        yearForegroundColor: WidgetStateColor.resolveWith((states) {
          return colorScheme.onSurface;
        }),
      ),
      cardColor: isDarkTheme ? AppColor.cardDark : AppColor.cardLight,
      hintColor: isDarkTheme ? AppColor.darkText2 : AppColor.lightText2,
      canvasColor: isDarkTheme ? AppColor.darkText3 : AppColor.lightText3,

      appBarTheme: AppBarTheme(
        elevation: 0.5,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
