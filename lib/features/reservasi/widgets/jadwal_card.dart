import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class ScheduleCardWidget extends StatelessWidget {
  final String namaPoli;
  final String namaDokter;
  final String hari;
  final String jam;

  final int quota;           
  final int kuotaTerpakai;   

  int get kuotaSisa => quota - kuotaTerpakai; 

  final VoidCallback onTap;

  const ScheduleCardWidget({
    super.key,
    required this.namaPoli,
    required this.namaDokter,
    required this.hari,
    required this.jam,
    required this.quota,
    required this.kuotaTerpakai,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.cardWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // POLI
          Text(
            namaPoli,
            style: AppTextStyles.heading.copyWith(
              color: AppColors.gold,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // Dokter
          Text(
            namaDokter,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          // Waktu
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text(
                "$hari | $jam",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
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
                "Kuota : $kuotaSisa/$quota",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Button Pilih
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  "Pilih",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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
