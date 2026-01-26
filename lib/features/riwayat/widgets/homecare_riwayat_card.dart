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
  final String? statusPembayaran; // Optional payment status parameter
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
    this.statusPembayaran, // Optional parameter
    required this.data,
    this.onTap,
  });

  Color statusColor() {
    // Cek beberapa kemungkinan field status dari backend
    final status =
        data['status_pembayaran']?.toString().toLowerCase().trim() ??
        data['status_pelunasan']?.toString().toLowerCase().trim() ??
        data['status_booking']?.toString().toLowerCase().trim() ??
        data['status']?.toString().toLowerCase().trim() ??
        '';

    switch (status) {
      case 'belum_lunas':
      case 'belum lunas':
      case 'pending':
      case 'menunggu':
        return Colors.orange;
      case 'lunas':
      case 'paid':
      case 'berhasil':
        return Colors.green;
      case 'gagal':
      case 'failed':
      case 'batal':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.goldDark; // fallback kalau null / tidak dikenal
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
                const Text('No.Pemeriksaan :'),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    noPemeriksaan,
                    style: AppTextStyles.heading.copyWith(fontSize: 16),
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

            // ================= CONTENT =================
            _infoRow('Dokter', dokter),
            _infoRow('Waktu', '$jamMulai - $jamSelesai'),
            _metodeRow('Metode Pembayaran', metodePembayaran),
            _totalRow('Total Pembayaran', 'Rp.$pembayaranTotal'),
          ],
        ),
      ),
    );
  }

  // ================= ROW BIASA =================
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelWidth, // SAMA DENGAN ROW LAIN
            child: Text('$label :', style: AppTextStyles.label),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOTAL PEMBAYARAN =================
  Widget _totalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
