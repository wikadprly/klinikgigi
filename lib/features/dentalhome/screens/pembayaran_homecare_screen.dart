import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import '../../../../core/services/home_care_service.dart';
import 'dart:async';

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

      // Navigate to payment instructions page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentInstructionsScreen(
            masterJadwalId: widget.masterJadwalId,
            tanggal: widget.tanggal,
            namaDokter: widget.namaDokter,
            jamPraktek: widget.jamPraktek,
            keluhan: widget.keluhan,
            alamat: widget.alamat,
            total: widget.rincianBiaya['estimasi_total'].toString(),
            metodePembayaran: _selectedPayment,
            bookingId: bookingData['id'], // Pass the booking ID for confirmation
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal booking: $e")));
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
        title: Text(
          "Ringkasan Pembayaran",
          style: AppTextStyles.heading,
        ),
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
                  _buildDetailRow(Icons.calendar_today, "Waktu", "${widget.tanggal} | ${widget.jamPraktek}"),
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
                    _buildPaymentRow("Biaya Layanan Home Care", biaya['biaya_layanan'].toString()),
                    SizedBox(height: 8),
                    _buildPaymentRow("Biaya Transportasi (${biaya['jarak_km']} km)", biaya['biaya_transport'].toString()),
                    Divider(color: AppColors.textMuted, thickness: 0.5),
                    _buildPaymentRow("Total Pembayaran", total.toString(), isTotal: true),
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
                  style: TextStyle(
                    color: AppColors.textMuted,
                  ),
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
                  style: TextStyle(
                    color: AppColors.textMuted,
                  ),
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
          Icon(
            icon,
            color: AppColors.textMuted,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.label,
                ),
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
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
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

// New Payment Instructions Screen
class PaymentInstructionsScreen extends StatefulWidget {
  final int masterJadwalId;
  final String tanggal;
  final String namaDokter;
  final String jamPraktek;
  final String keluhan;
  final String alamat;
  final String total;
  final String metodePembayaran;
  final int bookingId; // Added to track booking and confirm payment

  const PaymentInstructionsScreen({
    Key? key,
    required this.masterJadwalId,
    required this.tanggal,
    required this.namaDokter,
    required this.jamPraktek,
    required this.keluhan,
    required this.alamat,
    required this.total,
    required this.metodePembayaran,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<PaymentInstructionsScreen> createState() => _PaymentInstructionsScreenState();
}

class _PaymentInstructionsScreenState extends State<PaymentInstructionsScreen> {
  int _timeLeft = 600; // 10 minutes in seconds
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        // Navigate to success screen when timer expires
        // For now, we'll show a dialog; in real implementation, this might redirect to failure
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Waktu Habis"),
              content: Text("Pembayaran tidak dapat diproses karena waktu habis. Silakan coba lagi."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to payment selection
                  },
                  child: Text("Kembali"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        title: Text(
          widget.metodePembayaran == 'qris' ? "QRIS" : "Transfer Bank",
          style: AppTextStyles.heading,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Countdown Timer
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6), // Light red background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.red,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Bayar dalam ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatTime(_timeLeft),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Payment Details Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Total Pembayaran",
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Rp ${widget.total}",
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  if (widget.metodePembayaran == 'qris') ...[
                    // QRIS Code
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "QR CODE",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Scan QRIS di atas dengan aplikasi pembayaran favorit Anda",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.gold,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Save QR code to gallery functionality would go here
                        },
                        child: Text(
                          "Simpan Kode QR",
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Virtual Account Number
                    Text(
                      "Nomor Virtual Account",
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "123 4567 8901 2345",
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              color: AppColors.gold,
                            ),
                            onPressed: () {
                              // Copy functionality would go here
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Silakan transfer sesuai nominal ke rekening di atas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 20),

            // Payment Instructions
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
                    "Petunjuk Pembayaran",
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  if (widget.metodePembayaran == 'qris') ...[
                    _buildInstructionStep("1. Buka aplikasi pembayaran Anda (Gopay, OVO, Dana, LinkAja)"),
                    _buildInstructionStep("2. Pilih menu 'Scan QR'"),
                    _buildInstructionStep("3. Arahkan kamera ke Kode QR di atas"),
                    _buildInstructionStep("4. Pastikan nominal pembayaran sudah benar"),
                    _buildInstructionStep("5. Konfirmasi dan selesaikan pembayaran"),
                  ] else ...[
                    _buildInstructionStep("1. Buka aplikasi mobile banking atau kunjungi ATM terdekat"),
                    _buildInstructionStep("2. Pilih menu 'Transfer' ke rekening Virtual Account"),
                    _buildInstructionStep("3. Masukkan nomor Virtual Account di atas"),
                    _buildInstructionStep("4. Masukkan nominal sesuai total pembayaran"),
                    _buildInstructionStep("5. Konfirmasi dan selesaikan pembayaran"),
                  ],
                ],
              ),
            ),

            SizedBox(height: 20),

            // Payment Success Button (for simulation purposes)
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  // Confirm the payment with backend
                  final homeCareService = HomeCareService();
                  try {
                    await homeCareService.confirmPayment(widget.bookingId);

                    // Navigate to success page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSuccessScreen(
                          paymentNumber: "PAY${widget.bookingId}_${DateTime.now().millisecondsSinceEpoch}",
                          paymentMethod: widget.metodePembayaran,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal konfirmasi pembayaran: $e")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Konfirmasi Pembayaran",
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String step) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.split('. ')[0],
            style: TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              step.substring(step.indexOf('. ') + 2),
              style: TextStyle(
                color: AppColors.textMuted,
              ),
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
        title: Text(
          "Transaksi Berhasil",
          style: AppTextStyles.heading,
        ),
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
              child: Icon(
                Icons.check_circle,
                color: AppColors.gold,
                size: 60,
              ),
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
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
              ),
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
                  _buildTransactionDetail("No. Pembayaran", widget.paymentNumber),
                  SizedBox(height: 16),
                  _buildTransactionDetail("Metode Pembayaran",
                    widget.paymentMethod == 'qris' ? "QRIS" : "Transfer Bank"
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
                child: Text(
                  "Unduh Bukti",
                  style: AppTextStyles.button,
                ),
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
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),
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