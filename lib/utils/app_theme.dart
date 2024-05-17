import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'dart:math';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      primary: Colors.black,
      secondary: Colors.black,
      tertiary: Colors.black,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onTertiary: Colors.black,
    ),
    // colorSchemeSeed: Colors.black,
    // primarySwatch: generateMaterialColor(AppColor.black),
    useMaterial3: true,
    fontFamily: GoogleFonts.urbanist().fontFamily,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColor.black,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: GoogleFonts.urbanist().fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColor.black,
        letterSpacing: 1,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColor.lightGrey2,
      thickness: 1,
    ),
  );
}


MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
