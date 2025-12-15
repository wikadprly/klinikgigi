import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class HomeCareRiwayatCard extends StatelessWidget {
  final String noPemeriksaan;
  final String dokter;
  final String jamMulai;
  final String jamSelesai;
  final String pembayaranTotal;
  final String metodePembayaran;
  final String statusReservasi;
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const HomeCareRiwayatCard({
    super.key,
    required this.noPemeriksaan,
    required this.dokter,
    required this.jamMulai,
    required this.jamSelesai,
    required this.pembayaranTotal,
    required this.metodePembayaran,
    required this.statusReservasi,
    required this.data,
    this.onTap,
  });

  Color statusColor() {
    final s = statusReservasi.toLowerCase().trim();
    switch (s) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          border: Border.all(color: AppColors.gold, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 14, color: statusColor()),
                const SizedBox(width: 8),
                const Text('No. Pemeriksaan : '),
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
            Container(height: 1.5, color: AppColors.gold),
            const SizedBox(height: 8),
            _infoRow('Dokter', dokter),
            _infoRow('Waktu', '$jamMulai - $jamSelesai'),
            _infoRow('Total Pembayaran', 'Rp.$pembayaranTotal'),
            _infoRow('Metode Pembayaran', metodePembayaran),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
