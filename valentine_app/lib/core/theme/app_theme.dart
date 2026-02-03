import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final Color primary = Colors.pinkAccent;

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
    scaffoldBackgroundColor: const Color(0xFFFFF0F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    ),
    useMaterial3: true,
  );
}
