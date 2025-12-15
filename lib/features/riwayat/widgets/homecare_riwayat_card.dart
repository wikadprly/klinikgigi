import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

// ⬇️ LEBAR LABEL AGAR SEMUA SEJAJAR
const double _labelWidth = 170;

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
            // ================= HEADER =================
            Row(
              children: [
                Icon(Icons.circle, size: 14, color: statusColor()),
                const SizedBox(width: 8),
                Text(
                  'No. Pemeriksaan :',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    noPemeriksaan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Container(height: 1.5, color: AppColors.gold),
            const SizedBox(height: 8),

            // ================= CONTENT =================
            _infoRow('Dokter', dokter),
            _infoRow('Waktu', '$jamMulai - $jamSelesai'),
            _metodeRow('Metode Pembayaran', metodePembayaran),
            const SizedBox(height: 4),
            _totalRow('Total Pembayaran', 'Rp.$pembayaranTotal'),
          ],
        ),
      ),
    );
  }

  // ================= ROW BIASA =================
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text('$label :', style: AppTextStyles.label),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.label,
            ),
          ),
        ],
      ),
    );
  }

  // ================= METODE PEMBAYARAN =================
  Widget _metodeRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: _labelWidth, // SAMA DENGAN ROW LAIN
          child: Text(
            '$label :',
            style: AppTextStyles.label,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
  // ================= TOTAL PEMBAYARAN =================
  Widget _totalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text('$label :', style: AppTextStyles.label),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
