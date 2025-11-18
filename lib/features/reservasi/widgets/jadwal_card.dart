import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class ScheduleCardWidget extends StatelessWidget {
  final String namaPoli;
  final String namaDokter;
  final String hari;
  final String jam;

  /// Kuota dari backend
  final int kuotaSisa;
  final int kuotaTotal;

  final VoidCallback onTap;

  const ScheduleCardWidget({
    super.key,
    required this.namaPoli,
    required this.namaDokter,
    required this.hari,
    required this.jam,
    required this.kuotaSisa,
    required this.kuotaTotal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Poli
          Text(
            namaPoli,
            style: AppTextStyles.heading.copyWith(
              color: AppColors.gold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 6),

          // Nama Dokter
          Text(
            namaDokter,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 12),

          // Hari & Jam
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text(
                "$hari | $jam",
                style: AppTextStyles.label,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Kuota
          Row(
            children: [
              const Icon(Icons.group, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text(
                "Kuota : $kuotaSisa/$kuotaTotal",
                style: AppTextStyles.label,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Button Pilih
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Pilih",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
