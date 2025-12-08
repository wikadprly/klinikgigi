import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:intl/intl.dart'; // Pastikan package intl sudah ada
import 'package:qr_flutter/qr_flutter.dart';

class PembayaranQrisScreen extends StatefulWidget {
  final String expiredAt;
  final Map<String, dynamic> paymentData;

  const PembayaranQrisScreen({
    super.key,
    required this.expiredAt,
    required this.paymentData,
  });

  @override
  State<PembayaranQrisScreen> createState() => _PembayaranQrisScreenState();
}

class _PembayaranQrisScreenState extends State<PembayaranQrisScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  void _initTimer() {
    try {
      DateTime expiredTime = DateTime.parse(widget.expiredAt);
      DateTime now = DateTime.now();

      if (now.isAfter(expiredTime)) {
        setState(() {
          _isExpired = true;
          _timeLeft = Duration.zero;
        });
      } else {
        setState(() {
          _timeLeft = expiredTime.difference(now);
        });
        _startTimer(expiredTime);
      }
    } catch (e) {
      debugPrint("Error parsing date: $e");
      // Fallback safety 1 jam jika gagal parse
      setState(() {
        _timeLeft = const Duration(hours: 1);
      });
      _startTimer(DateTime.now().add(const Duration(hours: 1)));
    }
  }

  void _startTimer(DateTime expiredTime) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.isAfter(expiredTime)) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isExpired = true;
            _timeLeft = Duration.zero;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _timeLeft = expiredTime.difference(now);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  // Format Timer: 00 : 00 : 00
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours : $minutes : $seconds";
  }

  // Format Rupiah: Rp 25.000
  String _formatCurrency(dynamic amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    num val = 0;
    if (amount is num) {
      val = amount;
    } else if (amount is String) {
      val = num.tryParse(amount) ?? 0;
    }
    return formatter.format(val);
  }

  void _cekStatusPembayaran() {
    // Simulasi Cek Status
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Lihat Status",
          style: TextStyle(color: AppColors.gold),
        ),
        content: const Text(
          "Sedang memverifikasi pembayaran...",
          style: TextStyle(color: AppColors.textLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String qrisContent = widget.paymentData['qris_content'] ?? 'N/A';
    final dynamic amount = widget.paymentData['amount'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background, // Background Gelap
      appBar: AppBar(
        title: const Text("Scan QRIS", style: AppTextStyles.heading),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- 1. TIMER BOX (Merah Style) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: _isExpired
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isExpired ? Colors.red : Colors.red.withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _isExpired
                        ? "Kode QR Kadaluwarsa"
                        : "Selesaikan Pembayaran Dalam",
                    style: TextStyle(
                      color: _isExpired ? Colors.red : Colors.red[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(_timeLeft),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _isExpired ? Colors.red : Colors.red,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- 2. QR CARD (Putih) ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white, // Kartu Putih sesuai desain
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    "3K Dental Care",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "NMID: ID102003004005",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 24),

                  // QR Image
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: _isExpired
                        ? Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red[300],
                            ),
                          )
                        : QrImageView(
                            data: qrisContent,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                          ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Total Pembayaran",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(amount),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. INSTRUKSI PEMBAYARAN ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Cara Pembayaran:",
                style: TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildInstructionStep("1. Buka aplikasi e-wallet atau m-Banking."),
            _buildInstructionStep("2. Pilih menu Scan QR / Bayar."),
            _buildInstructionStep("3. Arahkan kamera ke kode QR di atas."),
            _buildInstructionStep("4. Periksa nama merchant dan nominal."),
            _buildInstructionStep("5. Selesaikan pembayaran."),

            const SizedBox(height: 30),

            // --- 4. TOMBOL CEK STATUS ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isExpired ? null : _cekStatusPembayaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey, // Sesuai desain (tombol abu-abu/silver)
                  disabledBackgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cek Status Pembayaran",
                  style: TextStyle(
                    color: Colors.white, // Teks putih
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 6, color: AppColors.textMuted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
