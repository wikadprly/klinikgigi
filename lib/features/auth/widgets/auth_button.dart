import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Future<void> Function()?
  onPressed; // ✅ ubah dari VoidCallback ke Future<void>
  final Color? textColor;
  final bool isDisabled; // ✅ tambahan: biar tombol bisa dinonaktifkan

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
      ),
    );
  }
}
