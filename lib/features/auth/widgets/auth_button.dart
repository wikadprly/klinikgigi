import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class AuthButton extends StatelessWidget {
  final String text;
<<<<<<< HEAD
  final VoidCallback? onPressed; // ✅ dibuat nullable biar bisa disable
  final Color? textColor;
  final bool isLoading; // ✅ tambahan opsional (kalau nanti mau loading animasi)
=======
  final Future<void> Function()?
  onPressed; // ✅ ubah dari VoidCallback ke Future<void>
  final Color? textColor;
  final bool isDisabled; // ✅ tambahan: biar tombol bisa dinonaktifkan
>>>>>>> main

  const AuthButton({
    super.key,
    required this.text,
<<<<<<< HEAD
    required this.onPressed,
    this.textColor,
    this.isLoading = false,
=======
    this.onPressed,
    this.textColor,
    this.isDisabled = false,
>>>>>>> main
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    final bool disabled = isDisabled || onPressed == null;

    return GestureDetector(
      onTap: disabled
          ? null
          : () async {
              // ✅ bungkus async di GestureDetector dengan try-catch
              try {
                await onPressed?.call();
              } catch (e) {
                debugPrint('Error in AuthButton: $e');
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: disabled
              ? LinearGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.4),
                    AppColors.goldDark.withOpacity(0.4),
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
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: textColor ?? AppColors.background,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
>>>>>>> main
          ),
        ),
      ),
    );
  }
}
