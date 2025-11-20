import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, String> doctor;
  final bool selected;
  final VoidCallback onSelect;

  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? Border.all(color: AppColors.gold, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Spesialisasi", style: AppTextStyles.input),
                const SizedBox(height: 6),
                Text(doctor['name']!, style: AppTextStyles.label),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(doctor['time']!, style: AppTextStyles.input),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.group, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text("Kuota : ${doctor['quota']}", style: AppTextStyles.label),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onSelect,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            ),
            child: const Text("Pilih", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
