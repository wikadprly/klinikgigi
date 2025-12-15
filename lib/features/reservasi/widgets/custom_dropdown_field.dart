import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
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

        // Dropdown Wrapper
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.cardWarm, // ⬅ Warm tone
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold, // ⬅ Gold elegan
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,

              // Background popup
              dropdownColor: AppColors.cardWarmDark, // ⬅ Lebih gelap, biar kontras

              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.gold,
                size: 22,
              ),

              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),

              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 15,
                    ),
                  ),
                );
              }).toList(),

              onChanged: onChanged,

              hint: const Text(
                'Pilih',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
