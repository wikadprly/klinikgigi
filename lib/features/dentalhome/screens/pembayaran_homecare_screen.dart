import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'pembayaran_qris_screen.dart';
import 'pembayaran_bank_screen.dart';

class PembayaranHomeCareScreen extends StatefulWidget {
  final int masterJadwalId;
  final String tanggal;
  final String namaDokter;
  final String jamPraktek;
  final String keluhan;
  final String alamat;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> rincianBiaya;

  const PembayaranHomeCareScreen({
    super.key,
    required this.masterJadwalId,
    required this.tanggal,
    required this.namaDokter,
    required this.jamPraktek,
    required this.keluhan,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.rincianBiaya,
  });

  @override
  State<PembayaranHomeCareScreen> createState() =>
      _PembayaranHomeCareScreenState();
}

class _PembayaranHomeCareScreenState extends State<PembayaranHomeCareScreen> {
  String _selectedPayment = 'transfer';

  void _lanjutKeLayarPembayaran() {
    final Map<String, dynamic> dataBookingMentah = {
      'masterJadwalId': widget.masterJadwalId,
      'tanggal': widget.tanggal,
      'namaDokter': widget.namaDokter,
      'jamPraktek': widget.jamPraktek,
      'keluhan': widget.keluhan,
      'alamat': widget.alamat,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
      'rincianBiaya': widget.rincianBiaya,
      'metodePembayaran': _selectedPayment,
    };

    if (_selectedPayment == 'qris') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PembayaranQrisScreen(bookingData: dataBookingMentah),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PembayaranBankScreen(bookingData: dataBookingMentah),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Konfirmasi & Pembayaran",
          style: AppTextStyles.heading,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Detail Pendaftaran ---
            Text(
              "Detail Pendaftaran",
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildDetailPendaftaranCard(),

            const SizedBox(height: 24),

            // --- 2. Rincian Biaya ---
            Text(
              "Rincian Biaya",
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildRincianBiayaCard(),

            const SizedBox(height: 24),

            // --- 3. Metode Pembayaran ---
            Text(
              "Metode Pembayaran",
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),

            _buildPaymentOption(
              value: 'transfer',
              title: "Transfer Bank",
              subtitle: "BCA, Mandiri, BNI, BRI",
              icon: Icons.account_balance,
            ),

            const SizedBox(height: 12),

            _buildPaymentOption(
              value: 'qris',
              title: "QRIS",
              subtitle: "Gopay, OVO, Dana, ShopeePay",
              icon: Icons.qr_code,
            ),

            const SizedBox(height: 40),

            // --- Tombol Lanjut ---
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: _lanjutKeLayarPembayaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Lanjut Pembayaran",
                  style: AppTextStyles.button,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Widget: Kartu Detail Pendaftaran ---
  Widget _buildDetailPendaftaranCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Dokter", widget.namaDokter),
          _buildInfoRow("Jadwal", "${widget.tanggal} • ${widget.jamPraktek}"),
          _buildInfoRow("Keluhan", widget.keluhan),
          _buildInfoRow("Lokasi", widget.alamat, isMultiLine: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
          const Text(": ", style: TextStyle(color: AppColors.textMuted)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: isMultiLine ? 3 : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget: Kartu Rincian Biaya ---
  Widget _buildRincianBiayaCard() {
    final biaya = widget.rincianBiaya;
    final layanan = biaya['biaya_layanan'] ?? 0;
    final transport = biaya['biaya_transport'] ?? 0;
    final total = biaya['estimasi_total'] ?? 0;
    final jarak = biaya['jarak_km'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          _buildCostRow("Biaya Layanan", layanan),
          _buildCostRow("Biaya Transport ($jarak km)", transport),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: AppColors.textMuted.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
          _buildCostRow("Total Pembayaran", total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, dynamic value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.textLight : AppColors.textMuted,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 15 : 13,
            ),
          ),
          Text(
            "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{3})$'), (m) => '.${m[1]}').replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (m) => '.${m[1]}')}",
            style: TextStyle(
              color: isTotal ? AppColors.gold : AppColors.textLight,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 13,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget: Opsi Pembayaran ---
  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPayment == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withValues(alpha: 0.1)
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.gold : AppColors.textLight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.gold),
          ],
        ),
      ),
    );
  }
}
