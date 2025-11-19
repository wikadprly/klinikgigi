import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
// Pastikan path ke AppColors sudah benar

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
        // Label Field
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),

        // Input Field (clickable)
        InkWell(
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(10),
              // Border emas
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Teks Tanggal yang Dipilih
                Text(
                  displayedDate ?? 'Pilih tanggal...', // Placeholder
                  style: TextStyle(
                    color: displayedDate != null
                        ? AppColors.textLight
                        : AppColors.textMuted,
                    fontSize: 16,
                  ),
                ),
                // Icon Calendar
                const Icon(
                  Icons.calendar_today,
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
