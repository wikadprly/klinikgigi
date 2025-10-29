import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ✅ dibuat nullable biar bisa disable
  final Color? textColor;
  final bool isLoading; // ✅ tambahan opsional (kalau nanti mau loading animasi)

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onPressed, // ✅ aman null check
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isDisabled ? 0.6 : 1.0, // efek tombol nonaktif
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isDisabled
                ? LinearGradient(
                    colors: [
                      AppColors.goldDark.withOpacity(0.5),
                      AppColors.gold.withOpacity(0.5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [AppColors.gold, AppColors.goldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (!isDisabled)
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.background),
                    ),
                  )
                : Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: textColor ?? AppColors.background,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
