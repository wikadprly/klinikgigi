import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
// Pastikan path relatif ke AppColors sudah benar

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
    const Color dropdownBgColor = AppColors.bgPanel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(10),
            // Border emas
            border: Border.all(color: AppColors.gold, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: dropdownBgColor,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.gold,
              ),
              style: const TextStyle(color: AppColors.textLight, fontSize: 16),
              items: items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              hint: Text('Pilih', style: TextStyle(color: AppColors.textMuted)),
            ),
          ),
        ),
      ],
    );
  }
}
