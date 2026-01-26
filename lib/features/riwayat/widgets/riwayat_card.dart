import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class RiwayatCard extends StatelessWidget {
  final String noPemeriksaan;
  final String dokter;
  final String tanggal;
  final String poli;
  final String statusReservasi;
  final String noAntrian;
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const RiwayatCard({
    super.key,
    required this.noPemeriksaan,
    required this.dokter,
    required this.tanggal,
    required this.poli,
    required this.statusReservasi,
    required this.noAntrian,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor() {
      // Extract status_pelunasan from data map if available, otherwise use reservation status
      final dataStatusPelunasan = data['status_pelunasan']?.toString();
      final status = (dataStatusPelunasan ?? statusReservasi).toLowerCase().trim();

      // First check for payment status values (from status_pelunasan column)
      switch (status) {
        case 'belum_lunas':
          return Colors.orange;
        case 'lunas':
          return Colors.green;
        case 'gagal':
          return Colors.red;
      }

      // Then check for reservation status values (fallback for backward compatibility)
      switch (status) {
        case 'menunggu':
          return Colors.orange;
        case 'dalam_proses':
        case 'dalam proses':
          return Colors.blue;
        case 'selesai':
          return Colors.green;
        case 'batal':
          return Colors.red;
        default:
          return AppColors.goldDark;
      }
    }

    String displayNoAntrian() {
      final v = noAntrian.trim();
      if (v.isEmpty || v == '-' || v.toLowerCase() == 'null') {
        return 'Menunggu Pembayaran';
      }
      return v;
    }

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
                Icon(Icons.circle, size: 14, color: statusColor()),
                const SizedBox(width: 6),
                const Text("No. Pemeriksaan : "),
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
            Container(
              height: 1.5,
              width: double.infinity,
              color: AppColors.gold,
            ),
            const SizedBox(height: 8),
            // Dokter
            _infoRow("No. Antrian :", displayNoAntrian()),
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
