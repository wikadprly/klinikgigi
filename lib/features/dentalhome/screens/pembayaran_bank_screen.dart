import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import '../../../core/services/home_care_service.dart';
import 'rincian_pembayaran.dart'; // Pastikan import ini ada

class PembayaranBankScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PembayaranBankScreen({super.key, required this.bookingData});

  @override
  State<PembayaranBankScreen> createState() => _PembayaranBankScreenState();
}

class _PembayaranBankScreenState extends State<PembayaranBankScreen> {
  bool _isLoading = true;
  String _virtualAccountNumber = "880098765432";
  String _bookingCode =
      "RSV-HC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
  String _nominal = "0";

  @override
  void initState() {
    super.initState();
    _nominal = widget.bookingData['rincianBiaya']['estimasi_total'].toString();
    _prosesBooking();
  }

  Future<void> _prosesBooking() async {
    try {
      // Simulasi delay API
      await Future.delayed(const Duration(seconds: 2));

      // Jika API sudah siap, uncomment kode di bawah:
      /*
      final result = await _service.createBooking(
        masterJadwalId: widget.bookingData['masterJadwalId'],
        tanggal: widget.bookingData['tanggal'],
        // ... parameter lain
        metodePembayaran: 'transfer',
      );
      if (mounted) {
        setState(() {
           _bookingCode = result['no_reservasi'] ?? _bookingCode;
           _virtualAccountNumber = result['payment_info']['va_number'] ?? _virtualAccountNumber;
        });
      }
      */
    } catch (e) {
      debugPrint("Error creating booking: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Helper data
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.gold),
                  SizedBox(height: 16),
                  Text(
                    "Membuat Pesanan...",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            )
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
                  Text(
                    "Detail Pendaftaran",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
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
                        _buildDetailRow("Keluhan", data['keluhan']),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ===== 3. RINCIAN PEMBAYARAN =====
                  Text(
                    "Rincian Pembayaran",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          "Biaya Layanan",
                          _formatRupiah(biaya['biaya_layanan']),
                        ),
                        _buildDetailRow(
                          "Transport (${biaya['jarak_km']} km)",
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

                  // ===== 4. AREA TRANSFER BANK (VIRTUAL ACCOUNT) =====
                  Text(
                    "Lakukan Pembayaran",
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.gold,
                      ), // Highlight border
                    ),
                    child: Column(
                      children: [
                        // Timer Sederhana
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer,
                                size: 16,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Sisa Waktu: 23 Jam 59 Menit",
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.account_balance,
                                color: AppColors.gold,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "BCA Virtual Account",
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Nomor VA
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.inputBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _virtualAccountNumber,
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: _virtualAccountNumber),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Nomor VA Disalin"),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.copy,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Instruksi Dropdown
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text(
                        "Lihat Petunjuk Transfer",
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      children: [
                        _buildInstructionStep("1. Buka aplikasi BCA Mobile"),
                        _buildInstructionStep(
                          "2. Pilih m-Transfer > BCA Virtual Account",
                        ),
                        _buildInstructionStep(
                          "3. Masukkan nomor: $_virtualAccountNumber",
                        ),
                        _buildInstructionStep("4. Masukkan PIN Anda"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Tombol Aksi
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // NAVIGASI KE NOTA PELUNASAN
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentDetailScreen(
                              transaction: {
                                'kode_booking': _bookingCode,
                                'nominal': _nominal,
                                'metode': 'Transfer Bank (BCA)',
                                'waktu': DateTime.now(),
                              },
                              invoiceId: _bookingCode,
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

  // --- Widgets Kecil ---

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

  Widget _buildInstructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: AppColors.textMuted)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
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