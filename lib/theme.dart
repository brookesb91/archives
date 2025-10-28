import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    fontFamily: 'Trade-Gothic',
    colorScheme: ColorScheme.light(
      primary: const Color(0xFFFFBA50),
      secondary: const Color(0xFF6E8581),
      surface: const Color(0xFFFEFEFE),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      surfaceTintColor: Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
  );

  static ThemeData get dark => ThemeData(
    fontFamily: 'Trade-Gothic',
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFFFBA50),
      secondary: const Color(0xFF6E8581),
      surface: const Color(0xFF242424),
    ),
    appBarTheme: AppBarTheme(backgroundColor: Color(0xFF030303)),
    scaffoldBackgroundColor: Color(0xFF242424),
  );
}
