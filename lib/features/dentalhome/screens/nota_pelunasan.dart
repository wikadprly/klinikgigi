import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:intl/intl.dart';

class NotaPelunasanScreen extends StatelessWidget {
  final Map<String, dynamic> transactionData;
  const NotaPelunasanScreen({super.key, required this.transactionData});

  @override
  Widget build(BuildContext context) {
    // Extract & Format Data
    final String kodeBooking = transactionData['kode_booking'] ?? '-';
    final String metode = transactionData['metode'] ?? '-';
    final String nominal = transactionData['nominal'].toString();

    // Handle Waktu
    DateTime waktuBayar;
    if (transactionData['waktu'] is DateTime) {
      waktuBayar = transactionData['waktu'];
    } else if (transactionData['waktu'] is String) {
      waktuBayar =
          DateTime.tryParse(transactionData['waktu']) ?? DateTime.now();
    } else {
      waktuBayar = DateTime.now();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // --- 1. Indikator Sukses ---
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Pembayaran Berhasil!",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 22,
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Terima kasih, pembayaran Anda telah terverifikasi.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),

              const SizedBox(height: 40),

              // --- 2. Kartu Rincian Transaksi ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.inputBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildReceiptRow(
                      "Kode Booking",
                      kodeBooking,
                      isBold: true,
                      valueColor: Colors.white,
                    ),
                    _buildDivider(),
                    _buildReceiptRow(
                      "Tanggal",
                      DateFormat('dd MMM yyyy').format(waktuBayar),
                    ),
                    _buildReceiptRow(
                      "Waktu",
                      DateFormat('HH:mm').format(waktuBayar),
                    ),
                    _buildReceiptRow("Metode Bayar", metode),
                    _buildReceiptRow(
                      "Status",
                      "LUNAS",
                      valueColor: Colors.greenAccent,
                      isBold: true,
                    ),
                    _buildDivider(),
                    _buildReceiptRow(
                      "Total Bayar",
                      _formatRupiah(nominal),
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // --- 3. Tombol Aksi ---

              // Tombol Unduh Bukti (Opsional)
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gold),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Nota berhasil disimpan ke galeri"),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.download_rounded,
                    color: AppColors.gold,
                  ),
                  label: Text(
                    "Unduh Bukti Bayar",
                    style: AppTextStyles.button.copyWith(color: AppColors.gold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Kembali ke Beranda
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Reset route ke dashboard (menghapus stack sebelumnya)
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Lihat Timeline Progres",
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets Helper ---

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.textLight : AppColors.textMuted,
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color:
                  valueColor ??
                  (isTotal ? AppColors.gold : AppColors.textLight),
              fontSize: isTotal ? 18 : 14,
              fontWeight: isBold || isTotal ? FontWeight.bold : FontWeight.w500,
              letterSpacing: isBold ? 0.5 : 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
        height: 1,
      ),
    );
  }

  String _formatRupiah(String nominal) {
    // Menghapus .0 jika ada
    double value = double.tryParse(nominal) ?? 0;
    String formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{3})$'), (Match m) => '.${m[1]}')
        .replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '.${m[1]}');
    return "Rp $formatted";
  }
}
