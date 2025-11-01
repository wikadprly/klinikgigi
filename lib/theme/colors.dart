import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0B0A0A);
  static const Color gold = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFF5C542);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFB0B0B0);
  static const Color inputBorder = Color(0xFF8D8D8D);
  static const Color white = Color(0xFFFFFFFF);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF9E68D), Color(0xFFB18D37)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const Color cardDark = Color(0xFF1B191D);
  static const Color navbarBackground = Color(0xFF2D2D2D);
}
