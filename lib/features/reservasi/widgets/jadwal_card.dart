import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class ScheduleCardWidget extends StatelessWidget {
  final String namaPoli;
  final String namaDokter;
  final String hari;
  final String jam;

  // 🔥 TAMBAHAN UI SAJA: Tanggal (Opsional)
  final String? tanggal;
  final String? statusJadwal; // Tambahkan status jadwal

  final int quota;
  final int kuotaTerpakai;

  final VoidCallback onTap;

  const ScheduleCardWidget({
    super.key,
    required this.namaPoli,
    required this.namaDokter,
    required this.hari,
    required this.jam,
    this.tanggal, // Boleh null
    this.statusJadwal, // Tambahkan parameter status jadwal
    required this.quota,
    required this.kuotaTerpakai,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Logic Kuota Penuh
    bool isFull = kuotaTerpakai >= quota;
    bool isLibur = statusJadwal == 'Libur'; // Tambahkan logika untuk status libur
    bool isAvailable = statusJadwal == 'Tersedia' && !isFull;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
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

          // Waktu (Hari + Tanggal + Jam)
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  // 🔥 TAMPILKAN TANGGAL DISINI
                  // Format: "Senin, 2025-12-05 | 08:00 - 12:00"
                  "$hari${tanggal != null ? ', $tanggal' : ''} | $jam",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                "Kuota : $kuotaTerpakai/$quota",
                style: AppTextStyles.label.copyWith(
                  color: isFull ? Colors.red : AppColors.textLight,
                  fontSize: 14,
                  fontWeight: isFull ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Status Jadwal
          Row(
            children: [
              const Icon(Icons.info, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text(
                "Status: ${statusJadwal ?? 'Tersedia'}",
                style: AppTextStyles.label.copyWith(
                  color: isLibur ? Colors.red : (isFull ? Colors.orange : AppColors.textLight),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Button Pilih
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: isAvailable ? onTap : null, // Hanya aktif jika tersedia
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isAvailable ? AppColors.gold : Colors.grey,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  isLibur ? "Libur" : (isFull ? "Penuh" : "Pilih"),
                  style: TextStyle(
                    color: isAvailable ? Colors.black : Colors.white,
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
