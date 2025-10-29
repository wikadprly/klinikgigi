import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    fontSize: 22,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.textMuted,
    fontSize: 14,
  );

  static const TextStyle input = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.textLight,
    fontSize: 16,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
}
