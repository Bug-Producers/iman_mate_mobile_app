import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme.g.dart';

@riverpod
class AppTheme extends _$AppTheme {
  static const Color _lightPrimary = Color(0xFF0891B2);
  static const Color _lightSecondary = Color(0xFFF59E0B);
  static const Color _lightBg = Color(0xFFF8FAFC);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightText = Color(0xFF0F172A);
  static const Color _lightTextSecondary = Color(0xFF64748B);

  static const Color _darkPrimary = Color(0xFF06B6D4);
  static const Color _darkSecondary = Color(0xFFFBBF24);
  static const Color _darkBg = Color(0xFF0F172A);
  static const Color _darkSurface = Color(0xFF1E293B);
  static const Color _darkText = Color(0xFFF1F5F9);
  static const Color _darkTextSecondary = Color(0xFF94A3B8);

  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    if (mode != ThemeMode.system) {
      state = mode;
    }
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  Color primaryColor() => state == ThemeMode.dark ? _darkPrimary : _lightPrimary;
  Color secondaryColor() => state == ThemeMode.dark ? _darkSecondary : _lightSecondary;
  Color bgColor() => state == ThemeMode.dark ? _darkBg : _lightBg;
  Color surfaceColor() => state == ThemeMode.dark ? _darkSurface : _lightSurface;
  Color textColor() => state == ThemeMode.dark ? _darkText : _lightText;
  Color textSecondaryColor() => state == ThemeMode.dark ? _darkTextSecondary : _lightTextSecondary;

  String getThemeStatus() => state == ThemeMode.dark ? "Dark Mode" : "Light Mode";


}