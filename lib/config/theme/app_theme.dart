import 'package:flutter/material.dart';

const Color _primaryColor = Color(0xFF67AF43);
// const Color _secondaryColor = Color(0xFF086D36);
// const Color _successColor = Color(0xFF8ACF00);
// const Color _infoColor = Color(0xFF909EC4);
// const Color _warningColor = Color(0xFFF3CB52);
// const Color _dangerColor = Color(0xFFDF333C);

// const List<Color> _colorThems = [
//   _primaryColor,
//   _secondaryColor,
//   _successColor,
//   _infoColor,
//   _warningColor,
//   _dangerColor,
// ];

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      colorSchemeSeed: _primaryColor,
      // brightness: Brightness.dark
    );
  }
}
