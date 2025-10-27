import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor; // ✅ tambahan properti

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor, // ✅ konstruktor disesuaikan
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gold, AppColors.goldDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color:
                  textColor ??
                  AppColors.background, // ✅ warna default bisa diubah dari luar
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
