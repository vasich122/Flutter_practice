import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: Colors.blue.shade800,
        secondary: Colors.orange.shade600,
        surface: Colors.white,
        error: Colors.red.shade700,
      ),
    );
  }
}
