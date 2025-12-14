import 'package:flutter/material.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: Colors.blue.shade800,
        secondary: Colors.orange.shade600,
        surface: Colors.white,
        error: Colors.red.shade700,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: Colors.blue.shade300,
        secondary: Colors.orange.shade400,
        surface: Colors.grey.shade900,
        error: Colors.red.shade400,
      ),
    );
  }

  static String themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  static AppThemeMode themeModeFromString(String? mode) {
    switch (mode) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.light;
    }
  }
}
