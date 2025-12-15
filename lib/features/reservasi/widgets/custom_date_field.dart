import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final String? displayedDate;
  final VoidCallback onTap;

  const CustomDateField({
    super.key,
    required this.label,
    this.displayedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Date Field Wrapper
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: AppColors.gold.withOpacity(0.15),
          highlightColor: AppColors.gold.withOpacity(0.08),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: displayedDate != null
                    ? AppColors.gold
                    : AppColors.goldDark.withOpacity(0.6),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text
                Text(
                  displayedDate ?? "Pilih tanggal...",
                  style: TextStyle(
                    color: displayedDate != null
                        ? AppColors.textLight
                        : AppColors.textMuted,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Calendar Icon
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.gold,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
