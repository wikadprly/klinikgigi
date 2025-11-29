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
    // 1. Cek apakah kuota penuh
    // Jika terpakai >= quota, berarti penuh.
    bool isFull = kuotaTerpakai >= quota;

    // 2. Hitung sisa untuk ditampilkan (Opsional, kalau mau tampilkan sisa)
    // int sisa = quota - kuotaTerpakai; 

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
                // Tampilan: "Kuota : 0/2" (Terpakai / Total) sesuai screenshotmu sebelumnya
                "Kuota : $kuotaTerpakai/$quota", 
                style: AppTextStyles.label.copyWith(
                  color: isFull ? Colors.red : AppColors.textLight, // Merah jika penuh
                  fontSize: 14,
                  fontWeight: isFull ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Button Pilih
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              // 3. Matikan onTap jika penuh
              onTap: isFull ? null : onTap, 
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  // 4. Ubah warna jadi abu-abu jika penuh
                  color: isFull ? Colors.grey : AppColors.gold,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  // 5. Ubah teks jadi "Penuh" jika penuh
                  isFull ? "Penuh" : "Pilih",
                  style: TextStyle(
                    color: isFull ? Colors.white : Colors.black,
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