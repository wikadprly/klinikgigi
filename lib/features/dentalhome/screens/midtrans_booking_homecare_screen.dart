import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Import Service & Helpers
import '../../../core/services/home_care_service.dart';
import '../../../core/storage/shared_prefs_helper.dart';
import '../../../theme/colors.dart';
import 'midtrans_webview_screen.dart'; // Pastikan file ini ada

class MidtransHomeCareBookingScreen extends StatefulWidget {
  final int masterJadwalId;
  final String tanggal;
  final String namaDokter;
  final String jamPraktek;
  final String keluhan;
  final String alamat;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> rincianBiaya;

  const MidtransHomeCareBookingScreen({
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
  State<MidtransHomeCareBookingScreen> createState() =>
      _MidtransHomeCareBookingScreenState();
}

class _MidtransHomeCareBookingScreenState
    extends State<MidtransHomeCareBookingScreen> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  late final HomeCareService _homeCareService;

  // Variable Polling Status
  Timer? _timerPolling;
  int? _currentBookingId;
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    _homeCareService = HomeCareService();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  void _stopPolling() {
    if (_timerPolling != null) {
      _timerPolling!.cancel();
      _timerPolling = null;
    }
    _isPolling = false;
  }

  // --- LOGIKA POLLING STATUS PEMBAYARAN ---
  void _startPollingStatus(int bookingId) {
    if (_isPolling) return;
    _isPolling = true;

    // Cek setiap 5 detik
    _timerPolling = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _checkStatusDiBackend(bookingId);
    });
  }

  Future<void> _checkStatusDiBackend(int bookingId) async {
    try {
      // Menggunakan service yang baru kita buat
      final statusData = await _homeCareService.checkPaymentStatus(bookingId);
      final statusPembayaran = statusData['status_pembayaran'];

      if (statusPembayaran == 'lunas' ||
          statusPembayaran == 'settlement' ||
          statusPembayaran == 'success') {
        _stopPolling();

        if (mounted) {
          // Tutup dialog loading jika ada
          Navigator.of(
            context,
          ).popUntil((route) => route.settings.name == null || route.isFirst);

          // Pindah ke Halaman Sukses
          _navigateToSuccessScreen();
        }
      }
    } catch (e) {
      debugPrint("Polling error: $e"); // Silent error log
    }
  }

  void _navigateToSuccessScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentSuccessScreen(bookingId: _currentBookingId),
      ),
    );
  }

  // --- PROSES UTAMA: CREATE BOOKING & DAPATKAN LINK ---
  Future<void> _prosesPembayaranMidtrans() async {
    // Tampilkan Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );

    try {
      final user = await SharedPrefsHelper.getUser();

      if (user == null) {
        if (mounted) Navigator.pop(context);
        _showSnackbar('Sesi habis. Silakan login ulang.', isError: true);
        return;
      }

      if (user.rekamMedisId == null) {
        if (mounted) Navigator.pop(context);
        _showSnackbar(
          'Data pasien tidak lengkap. Silakan perbarui profil.',
          isError: true,
        );
        return;
      }

      // Panggil Service createBooking
      final result = await _homeCareService.createBooking(
        rekamMedisId: user.rekamMedisId!,
        masterJadwalId: widget.masterJadwalId,
        tanggal: widget.tanggal,
        keluhan: widget.keluhan,
        lat: widget.latitude,
        lng: widget.longitude,
        alamat: widget.alamat,
        metodePembayaran: 'midtrans',
      );

      if (mounted) Navigator.pop(context); // Tutup Loading

      // Parsing Response Baru (Map<String, dynamic>)
      // Struktur: { 'booking': Object, 'payment_info': Map }
      final bookingObj = result['booking'];
      final paymentInfo = result['payment_info'];

      if (bookingObj != null && paymentInfo != null) {
        final bookingId = bookingObj.id; // Dari Model HomeCareBooking
        final redirectUrl = paymentInfo['redirect_url'];
        final noPemeriksaan = bookingObj.noPemeriksaan;

        // Simpan ID untuk Polling
        _currentBookingId = bookingId;

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          // Buka Halaman Pembayaran
          _launchPayment(redirectUrl, noPemeriksaan);
        } else {
          _showSnackbar('Gagal mendapatkan link pembayaran.', isError: true);
        }
      } else {
        _showSnackbar('Format respon server tidak valid.', isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Tutup loading jika error
      _showSnackbar('Terjadi kesalahan: ${e.toString()}', isError: true);
    }
  }

  // Launch payment (Hybrid Logic: Web vs App)
  Future<void> _launchPayment(String urlString, String noPemeriksaan) async {
    // Mulai polling di background
    if (_currentBookingId != null) _startPollingStatus(_currentBookingId!);

    // A. LOGIKA WEB / BROWSER LUAR (Fallback Aman)
    if (kIsWeb) {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (mounted) _showWaitingPaymentDialog();
      }
    } else {
      // B. LOGIKA ANDROID (WebView Dalam Aplikasi)
      // Kita buka screen WebView khusus
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MidtransWebViewScreen(
            url: urlString,
            noPemeriksaan: noPemeriksaan,
          ),
        ),
      );

      // Setelah user menutup WebView (tekan back/close), cek status sekali lagi
      if (_currentBookingId != null) {
        // Tampilkan loading sebentar saat cek status final
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }

        await _checkStatusDiBackend(_currentBookingId!);

        if (mounted) {
          Navigator.pop(context); // Tutup loading
          // Jika belum lunas, biarkan user di halaman ini atau arahkan ke Riwayat
        }
      }
    }
  }

  void _showWaitingPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.cardDark,
          title: const Text(
            "Menunggu Pembayaran",
            style: TextStyle(color: AppColors.gold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Silakan selesaikan pembayaran di browser.\nAplikasi akan otomatis mendeteksi jika berhasil.",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(color: AppColors.gold, backgroundColor: Colors.white10),
              SizedBox(height: 10),
              Text(
                "Jangan tutup halaman ini",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Memeriksa status pembayaran..."),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
                if (_currentBookingId != null) {
                  await _checkStatusDiBackend(_currentBookingId!);
                }
              },
              child: const Text("Cek Status Manual", style: TextStyle(color: AppColors.gold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message),
      ),
    );
  }

  // --- BUILD UI ---
  @override
  Widget build(BuildContext context) {
    final biaya = widget.rincianBiaya;
    // Safety check type data karena JSON kadang int kadang double
    final total = (biaya['estimasi_total'] is int)
        ? biaya['estimasi_total']
        : (biaya['estimasi_total'] as double).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Konfirmasi & Pembayaran"),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Detail Pendaftaran
            const Text(
              "Detail Pendaftaran",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailCard(),

            const SizedBox(height: 24),

            // 2. Rincian Biaya
            const Text(
              "Rincian Biaya",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildBiayaCard(),

            const SizedBox(height: 24),

            // 3. Info Metode Pembayaran
            _buildPaymentMethodCard(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.cardDark,
          border: Border(top: BorderSide(color: Colors.white12)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _prosesPembayaranMidtrans,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Lanjut Pembayaran (${currencyFormatter.format(total)})",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER UI ---
  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          _rowDetail("Dokter", widget.namaDokter),
          _rowDetail("Jadwal", "${widget.tanggal} • ${widget.jamPraktek}"),
          _rowDetail("Keluhan", widget.keluhan),
          _rowDetail("Lokasi", widget.alamat, isMultiline: true),
        ],
      ),
    );
  }

  Widget _buildBiayaCard() {
    final biaya = widget.rincianBiaya;
    final layanan = biaya['biaya_layanan'] ?? 0;
    final transport = biaya['biaya_transport'] ?? 0;
    final total = biaya['estimasi_total'] ?? 0;
    final jarak = biaya['jarak_km'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          _rowBiaya("Biaya Layanan", layanan),
          _rowBiaya("Biaya Transport ($jarak km)", transport),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                currencyFormatter.format(total),
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
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF2C2C2C),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.payment, color: AppColors.gold),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pembayaran Online",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "QRIS, GoPay, ShopeePay, Transfer Bank (VA)",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.gold),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          const Text(": ", style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
              maxLines: isMultiline ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowBiaya(String label, dynamic value) {
    // Safety cast
    final num val = (value is num) ? value : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            currencyFormatter.format(val),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// --- SCREEN SUKSES ---
class PaymentSuccessScreen extends StatelessWidget {
  final int? bookingId;
  const PaymentSuccessScreen({super.key, this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.gold, size: 100),
            const SizedBox(height: 20),
            const Text(
              "Transaksi Berhasil",
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Pembayaran terverifikasi. Dokter akan segera datang.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                fixedSize: const Size(200, 45),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home', // Ganti dengan route home Anda
                  (route) => false,
                );
              },
              child: const Text(
                "Kembali ke Beranda",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
