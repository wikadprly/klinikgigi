import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'nota_pelunasan.dart'; // Pastikan import ini ada

class PembayaranQrisScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PembayaranQrisScreen({super.key, required this.bookingData});

  @override
  State<PembayaranQrisScreen> createState() => _PembayaranQrisScreenState();
}

class _PembayaranQrisScreenState extends State<PembayaranQrisScreen> {
  bool _isLoading = true;
  String _qrContent = "KlinikGigi-HC-${DateTime.now().millisecondsSinceEpoch}";
  String _bookingCode =
      "RSV-HC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

  @override
  void initState() {
    super.initState();
    _prosesBooking();
  }

  Future<void> _prosesBooking() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      // Logika API (uncomment jika siap)
      /*
      final result = await _service.createBooking( ... );
      setState(() {
         _bookingCode = result['no_reservasi'];
         _qrContent = result['qr_string'];
      });
      */
    } catch (e) {
      debugPrint("Error QRIS: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Helper Data
    final data = widget.bookingData;
    final biaya = data['rincianBiaya'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Metode Pembayaran", style: AppTextStyles.heading),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.gold))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // ===== 1. KODE BOOKING =====
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Kode Booking",
                          style: AppTextStyles.label.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _bookingCode,
                          style: AppTextStyles.heading.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ===== 2. DETAIL PENDAFTARAN =====
                  Text("Detail Pendaftaran", style: _sectionTitleStyle),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration,
                    child: Column(
                      children: [
                        _buildDetailRow("Layanan", "Home Care Gigi"),
                        _buildDetailRow("Dokter", data['namaDokter']),
                        _buildDetailRow(
                          "Waktu",
                          "${data['tanggal']} • ${data['jamPraktek']}",
                        ),
                        _buildDetailRow(
                          "Alamat",
                          data['alamat'],
                          isMultiLine: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ===== 3. RINCIAN PEMBAYARAN =====
                  Text("Rincian Pembayaran", style: _sectionTitleStyle),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration,
                    child: Column(
                      children: [
                        _buildDetailRow(
                          "Biaya Layanan",
                          _formatRupiah(biaya['biaya_layanan']),
                        ),
                        _buildDetailRow(
                          "Transport",
                          _formatRupiah(biaya['biaya_transport']),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Colors.white24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Pembayaran",
                              style: TextStyle(color: AppColors.textLight),
                            ),
                            Text(
                              _formatRupiah(biaya['estimasi_total']),
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ===== 4. AREA QRIS =====
                  Text("Scan QRIS", style: _sectionTitleStyle),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.gold,
                          width: 4,
                        ), // Border Emas Tebal
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo_klinik_kecil.png',
                            height: 30,
                            errorBuilder: (c, o, s) => const SizedBox(),
                          ),
                          const SizedBox(height: 10),
                          QrImageView(
                            data: _qrContent,
                            version: QrVersions.auto,
                            size: 220.0,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Scan QRIS untuk Bayar",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Berlaku untuk semua e-Wallet",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Tombol Selesai
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // 🔥 NAVIGASI KE NOTA PELUNASAN
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TagihanPage(
                              noPemeriksaan: _bookingCode,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cek Status Pembayaran",
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

  // Styles & Helpers
  TextStyle get _sectionTitleStyle => AppTextStyles.heading.copyWith(
    color: AppColors.textLight,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: AppColors.cardDark,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.inputBorder),
  );

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  String _formatRupiah(dynamic nominal) {
    return "Rp ${nominal.toString().replaceAllMapped(RegExp(r'(\d{3})$'), (m) => '.${m[1]}').replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (m) => '.${m[1]}')}";
  }
}
