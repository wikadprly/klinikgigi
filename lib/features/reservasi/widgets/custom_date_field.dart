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
        Text(
          label,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.gold.withOpacity(0.15),
          highlightColor: AppColors.gold.withOpacity(0.08),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.cardWarm,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold, width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayedDate ?? "Pilih tanggal...",
                  style: TextStyle(
                    color: displayedDate != null ? AppColors.textLight : AppColors.textMuted,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.calendar_today_rounded, color: AppColors.gold, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}