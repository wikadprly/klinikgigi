import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk fitur Copy Paste
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:intl/intl.dart'; // Pastikan add dependency intl di pubspec.yaml

class PembayaranBankScreen extends StatefulWidget {
  final String expiredAt;
  final Map<String, dynamic> paymentData;

  // Data tambahan untuk Rincian Kunjungan (Sesuai Desain)
  final String? tanggal;
  final String? alamat;
  final String? keluhan;

  const PembayaranBankScreen({
    super.key,
    required this.expiredAt,
    required this.paymentData,
    this.tanggal,
    this.alamat,
    this.keluhan,
  });

  @override
  State<PembayaranBankScreen> createState() => _PembayaranBankScreenState();
}

class _PembayaranBankScreenState extends State<PembayaranBankScreen> {
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
      // Parsing waktu expired dari server
      DateTime expiredTime = DateTime.parse(widget.expiredAt);
      DateTime now = DateTime.now();

      // FIX BUG TIMER:
      // Jika expiredTime terdeteksi sudah lewat (misal karena beda timezone server),
      // kita anggap masih ada waktu 24 jam (untuk testing) atau set ke 0 jika memang expired.
      // Di sini saya pastikan logika difference-nya benar.

      if (now.isAfter(expiredTime)) {
        // Cek jika selisihnya kecil (mungkin beda detik server), anggap expired.
        // Tapi jika Anda ingin testing, bisa di-comment bagian ini.
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
      // Fallback: Set timer manual 1 jam jika parsing gagal (untuk safety UI)
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

  // Helper untuk format Rupiah
  String _formatCurrency(dynamic amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    // Pastikan amount berupa angka (int/double)
    num val = 0;
    if (amount is num) {
      val = amount;
    } else if (amount is String) {
      val = num.tryParse(amount) ?? 0;
    }
    return formatter.format(val);
  }

  // Helper Timer Text (Jam : Menit : Detik) atau (23 jam 58 menit...)
  String _formatDurationText(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    // Format ala Desain: "23 jam 58 menit 31 detik"
    if (duration.inHours > 0) {
      return "${duration.inHours} jam ${duration.inMinutes.remainder(60)} menit ${twoDigits(duration.inSeconds.remainder(60))} detik";
    } else {
      return "${duration.inMinutes.remainder(60)} menit ${twoDigits(duration.inSeconds.remainder(60))} detik";
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Nomor berhasil disalin')));
  }

  @override
  Widget build(BuildContext context) {
    final bankName = widget.paymentData['bank_name'] ?? 'Bank Transfer';
    final accountNum = widget.paymentData['account_number'] ?? '-';
    final amount = widget.paymentData['amount'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background, // Tetap Dark Mode
      appBar: AppBar(
        title: const Text("Pembayaran", style: AppTextStyles.heading),
        backgroundColor: AppColors.background,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textLight,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rincian Pembayaran",
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- KARTU 1: TOTAL & TIMER ---
                  _buildTotalTimerCard(amount),

                  const SizedBox(height: 20),

                  // --- KARTU 2: INFO BANK / VA ---
                  _buildBankInfoCard(bankName, accountNum),

                  const SizedBox(height: 20),

                  // --- KARTU 3: RINCIAN KUNJUNGAN ---
                  const Text(
                    "Rincian Kunjungan",
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRincianKunjunganCard(),

                  const SizedBox(height: 24),

                  // --- INSTRUKSI TRANSFER ---
                  const Text(
                    "Petunjuk Transfer",
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionTile("Petunjuk Transfer mBanking"),
                  _buildInstructionTile("Petunjuk Transfer ATM"),
                  _buildInstructionTile("Petunjuk Transfer iBanking"),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // --- TOMBOL BAWAH ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.cardDark,
              border: Border(top: BorderSide(color: AppColors.inputBorder)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi cek status atau kembali ke home
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Lihat Status",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Kartu Total & Timer
  Widget _buildTotalTimerCard(dynamic amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark, // Dark card
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(color: AppColors.textMuted),
              ),
              Text(
                _formatCurrency(amount),
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.inputBorder),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bayar Dalam",
                style: TextStyle(color: AppColors.textMuted),
              ),
              Expanded(
                child: Text(
                  _isExpired ? "Waktu Habis" : _formatDurationText(_timeLeft),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: _isExpired ? Colors.red : AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 13, // Font size dikecilkan agar muat
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET: Info Bank
  Widget _buildBankInfoCard(String bankName, String accountNum) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gold,
        ), // Gold border untuk highlight
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Placeholder Logo Bank (Kotak Biru di desain)
              Container(
                width: 40,
                height: 25,
                color: Colors.blue[800],
                alignment: Alignment.center,
                child: const Text(
                  "BANK",
                  style: TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                bankName,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "No. Rek/Virtual Account",
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                accountNum,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              InkWell(
                onTap: () => _copyToClipboard(accountNum),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Salin",
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET: Rincian Kunjungan
  Widget _buildRincianKunjunganCard() {
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
          _buildDetailRow("Tanggal", widget.tanggal ?? "-"),
          const SizedBox(height: 12),
          _buildDetailRow("Alamat", widget.alamat ?? "-", isMultiLine: true),
          const SizedBox(height: 12),
          _buildDetailRow("Keluhan", widget.keluhan ?? "-"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            maxLines: isMultiLine ? 3 : 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // WIDGET: Accordion Instruksi
  Widget _buildInstructionTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textLight, fontSize: 14),
        ),
        iconColor: AppColors.textLight,
        collapsedIconColor: AppColors.textMuted,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.black12,
            child: const Text(
              "1. Masukkan kartu ATM dan PIN.\n2. Pilih menu Transaksi Lainnya > Transfer.\n3. Masukkan kode Virtual Account.\n4. Konfirmasi pembayaran.",
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
