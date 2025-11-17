import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class RiwayatCard extends StatelessWidget {
  final String noPemeriksaan;
  final String dokter;
  final String tanggal;
  final String poli;
  final String statusReservasi;
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const RiwayatCard({
    super.key,
    required this.noPemeriksaan,
    required this.dokter,
    required this.tanggal,
    required this.poli,
    required this.statusReservasi,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelesai = statusReservasi.toLowerCase() == "selesai";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          border: Border.all(color: AppColors.gold, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris pertama: status + nomor pemeriksaan
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 14,
                  color: isSelesai ? AppColors.gold : AppColors.goldDark,
                ),
                const SizedBox(width: 6),
                const Text("No. Pemeriksaan : ", style: AppTextStyles.heading),
                Expanded(
                  child: Text(
                    noPemeriksaan,
                    style: AppTextStyles.heading,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Dokter
            _infoRow("Dokter :", dokter),
            _infoRow("Tanggal :", tanggal),
            _infoRow("Poli :", poli),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: AppTextStyles.label)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.label,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
