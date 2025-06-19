import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF67AF43),
          primary: const Color(0xFF67AF43),
          secondary: const Color(0xFF086D36),
          error: const Color(0xFFDF333C),
          tertiary: const Color(0xFF8ACF00),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onTertiary: Colors.white,
          onSurface: Colors.black,
        ),
      );
}
