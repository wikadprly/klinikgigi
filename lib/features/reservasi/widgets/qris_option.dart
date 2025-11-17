import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class QrisOption extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const QrisOption({super.key, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.cardDark;

    final borderColor = isSelected
        ? AppColors.goldDark
        : AppColors.goldDark.withValues(alpha: 0.25);

    final innerColor = isSelected
        ? AppColors.goldDark.withValues(alpha: 0.12)
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // Ikon QRIS
            Container(
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                color: innerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.qr_code, color: AppColors.goldDark, size: 30),
              ),
            ),

            const SizedBox(width: 12),

            // Teks QRIS
            Expanded(
              child: Text(
                "QRIS",
                style: AppTextStyles.input.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Lingkaran indikator
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textLight.withValues(alpha: 0.9),
                  width: 1.6,
                ),
                color: isSelected ? Colors.white : Colors.transparent,
              ),
              child: !isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
