import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import '../../../../core/services/home_care_service.dart';
import 'dart:async';
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
  final Map<String, dynamic>
  rincianBiaya; // {'biaya_transport', 'biaya_layanan', 'estimasi_total'}

  const PembayaranHomeCareScreen({
    Key? key,
    required this.masterJadwalId,
    required this.tanggal,
    required this.namaDokter,
    required this.jamPraktek,
    required this.keluhan,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.rincianBiaya,
  }) : super(key: key);

  @override
  State<PembayaranHomeCareScreen> createState() =>
      _PembayaranHomeCareScreenState();
}

class _PembayaranHomeCareScreenState extends State<PembayaranHomeCareScreen> {
  final HomeCareService _service = HomeCareService();
  String _selectedPayment = 'transfer'; // Default
  bool _isProcessing = false;

  Future<void> _bayarSekarang() async {
    setState(() => _isProcessing = true);

    try {
      // Validate token before attempting booking so we can fail early with clear message
      final tokenValid = await _service.validateToken();
      if (!tokenValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi Anda telah berakhir. Silakan login kembali.'),
          ),
        );
        setState(() => _isProcessing = false);
        // Navigate back to root so user can login
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
      // Create booking and get the booking data
      final bookingData = await _service.createBooking(
        masterJadwalId: widget.masterJadwalId,
        tanggal: widget.tanggal,
        keluhan: widget.keluhan,
        lat: widget.latitude,
        lng: widget.longitude,
        alamat: widget.alamat,
        metodePembayaran: _selectedPayment,
      );

      // Navigate to the appropriate payment screen based on the selected method
      if (_selectedPayment == 'qris') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranQrisScreen(
              bookingData: {
                'masterJadwalId': widget.masterJadwalId,
                'tanggal': widget.tanggal,
                'namaDokter': widget.namaDokter,
                'jamPraktek': widget.jamPraktek,
                'keluhan': widget.keluhan,
                'alamat': widget.alamat,
                'latitude': widget.latitude,
                'longitude': widget.longitude,
                'rincianBiaya': widget.rincianBiaya,
                'bookingId':
                    bookingData['id'], // Pass the booking ID for confirmation
              },
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranBankScreen(
              bookingData: {
                'masterJadwalId': widget.masterJadwalId,
                'tanggal': widget.tanggal,
                'namaDokter': widget.namaDokter,
                'jamPraktek': widget.jamPraktek,
                'keluhan': widget.keluhan,
                'alamat': widget.alamat,
                'latitude': widget.latitude,
                'longitude': widget.longitude,
                'rincianBiaya': widget.rincianBiaya,
                'bookingId':
                    bookingData['id'], // Pass the booking ID for confirmation
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Cek apakah error adalah Unauthorized (401)
      if (e.toString().contains('401') ||
          e.toString().toLowerCase().contains('unauthorized')) {
        // Tampilkan pesan bahwa sesi telah habis, tanpa navigasi ke halaman yang tidak ditemukan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Sesi Anda telah berakhir. Silakan login kembali di halaman utama.",
            ),
          ),
        );

        // Reset state untuk mencegah UI tetap dalam mode loading
        setState(() => _isProcessing = false);

        // Kembalikan ke layar sebelumnya atau ke home screen
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal booking: $e")));
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final biaya = widget.rincianBiaya;
    final total = biaya['estimasi_total'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        title: Text("Ringkasan Pembayaran", style: AppTextStyles.heading),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Detail Pendaftaran - Premium dark card with gold accents
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Pendaftaran",
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(Icons.medical_services, "Poli", "Home Care"),
                  _buildDetailRow(Icons.person, "Dokter", widget.namaDokter),
                  _buildDetailRow(
                    Icons.calendar_today,
                    "Waktu",
                    "${widget.tanggal} | ${widget.jamPraktek}",
                  ),
                  _buildDetailRow(Icons.location_on, "Lokasi", widget.alamat),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Rincian Pembayaran
            Text(
              "Rincian Pembayaran",
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
            SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPaymentRow(
                      "Biaya Layanan Home Care",
                      biaya['biaya_layanan'].toString(),
                    ),
                    SizedBox(height: 8),
                    _buildPaymentRow(
                      "Biaya Transportasi (${biaya['jarak_km']} km)",
                      biaya['biaya_transport'].toString(),
                    ),
                    Divider(color: AppColors.textMuted, thickness: 0.5),
                    _buildPaymentRow(
                      "Total Pembayaran",
                      total.toString(),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Metode Pembayaran
            Text(
              "Metode Pembayaran",
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
            SizedBox(height: 12),

            // Transfer Bank Option
            Container(
              decoration: BoxDecoration(
                color: _selectedPayment == 'transfer'
                    ? AppColors.gold.withOpacity(0.1)
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedPayment == 'transfer'
                      ? AppColors.gold
                      : AppColors.inputBorder,
                  width: _selectedPayment == 'transfer' ? 2 : 1,
                ),
              ),
              child: RadioListTile<String>(
                activeColor: AppColors.gold,
                title: Text(
                  "Transfer Bank",
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: _selectedPayment == 'transfer'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  "BCA, Mandiri, BRI, BNI",
                  style: TextStyle(color: AppColors.textMuted),
                ),
                value: 'transfer',
                groupValue: _selectedPayment,
                onChanged: (val) => setState(() => _selectedPayment = val!),
              ),
            ),

            SizedBox(height: 12),

            // QRIS Option
            Container(
              decoration: BoxDecoration(
                color: _selectedPayment == 'qris'
                    ? AppColors.gold.withOpacity(0.1)
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedPayment == 'qris'
                      ? AppColors.gold
                      : AppColors.inputBorder,
                  width: _selectedPayment == 'qris' ? 2 : 1,
                ),
              ),
              child: RadioListTile<String>(
                activeColor: AppColors.gold,
                title: Text(
                  "QRIS",
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: _selectedPayment == 'qris'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  "Gopay, OVO, Dana, LinkAja",
                  style: TextStyle(color: AppColors.textMuted),
                ),
                value: 'qris',
                groupValue: _selectedPayment,
                onChanged: (val) => setState(() => _selectedPayment = val!),
              ),
            ),

            SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _bayarSekarang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isProcessing ? "Memproses..." : "Bayar & Konfirmasi",
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textMuted, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label),
                Text(
                  value,
                  style: AppTextStyles.input.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          Text(
            "Rp ${value.replaceAllMapped(RegExp(r'(\d{3})$'), (Match m) => '${m[1]}')}",
            style: TextStyle(
              color: isTotal ? AppColors.gold : AppColors.textLight,
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Success Screen
class PaymentSuccessScreen extends StatefulWidget {
  final String paymentNumber;
  final String paymentMethod;

  const PaymentSuccessScreen({
    Key? key,
    required this.paymentNumber,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
        title: Text("Transaksi Berhasil", style: AppTextStyles.heading),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Success Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: AppColors.gold, size: 60),
            ),
            SizedBox(height: 20),

            Text(
              "Pembayaran Berhasil!",
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Terima kasih telah melakukan pembayaran",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),

            SizedBox(height: 30),

            // Transaction Summary Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTransactionDetail(
                    "No. Pembayaran",
                    widget.paymentNumber,
                  ),
                  SizedBox(height: 16),
                  _buildTransactionDetail(
                    "Metode Pembayaran",
                    widget.paymentMethod == 'qris' ? "QRIS" : "Transfer Bank",
                  ),
                  SizedBox(height: 16),
                  _buildTransactionDetail("Status Pembayaran", "Lunas"),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Action Buttons
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gold),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigate to track visit functionality would go here
                  // For now, navigate back to home
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  "Lacak Kunjungan",
                  style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigate to download receipt functionality would go here
                },
                child: Text("Unduh Bukti", style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
