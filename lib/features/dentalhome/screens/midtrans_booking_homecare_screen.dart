import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:flutter_klinik_gigi/config/api.dart';
import 'package:url_launcher/url_launcher.dart';
// Pastikan file ini ada
import 'midtrans_webview_screen.dart';

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

  // Variable Polling
  Timer? _timerPolling;
  int? _currentBookingId;
  bool _isPolling = false;

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
  }

  // --- LOGIKA POLLING ---
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
      final token = await SharedPrefsHelper.getToken();
      final url = Uri.parse('$baseUrl/homecare/booking/$bookingId/status');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final statusPembayaran = data['data']['status_pembayaran'];

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
      }
    } catch (e) {
      debugPrint("Error polling: $e");
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

  // --- PROSES PEMBAYARAN ---
  Future<void> _prosesPembayaranMidtrans() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );

    final url = Uri.parse(ApiEndpoint.homeCareBook);

    try {
      final token = await SharedPrefsHelper.getToken();
      final user = await SharedPrefsHelper.getUser();

      if (token == null || user == null) {
        if (mounted) Navigator.pop(context);
        _showSnackbar('Sesi habis. Silakan login ulang.', isError: true);
        return;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rekam_medis_id': user.rekamMedisId,
          'master_jadwal_id': widget.masterJadwalId,
          'tanggal': widget.tanggal,
          'keluhan': widget.keluhan,
          'latitude_pasien': widget.latitude,
          'longitude_pasien': widget.longitude,
          'alamat_lengkap': widget.alamat,
          'metode_pembayaran': 'midtrans',
        }),
      );

      if (mounted) Navigator.pop(context); // Tutup Loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respData = jsonDecode(response.body);

        // Simpan Booking ID untuk Polling
        if (respData['data'] != null && respData['data']['id'] != null) {
          _currentBookingId = respData['data']['id'];
        }

        // Ambil URL Redirect
        String? redirectUrl;
        if (respData['payment_info'] != null) {
          redirectUrl = respData['payment_info']['redirect_url'];
        } else if (respData['data'] != null) {
          redirectUrl = respData['data']['redirect_url'];
        }

        if (redirectUrl != null) {
          _launchPayment(redirectUrl);
        } else {
          _showSnackbar('Gagal mendapatkan link pembayaran.', isError: true);
        }
      } else {
        _showSnackbar('Gagal: ${response.body}', isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackbar('Terjadi kesalahan: $e', isError: true);
    }
  }

  // Launch payment (Hybrid Logic)
  Future<void> _launchPayment(String urlString) async {
    // A. LOGIKA WEB / BROWSER LUAR (Fallback Aman)
    if (kIsWeb) {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (_currentBookingId != null) _startPollingStatus(_currentBookingId!);
        if (mounted) _showWaitingPaymentDialog();
      }
    } else {
      // B. LOGIKA ANDROID (WebView Dalam Aplikasi)
      if (_currentBookingId != null) _startPollingStatus(_currentBookingId!);

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MidtransWebViewScreen(url: urlString),
        ),
      );

      // Jika user menekan tombol back dari webview, cek status sekali lagi
      if (_currentBookingId != null) _checkStatusDiBackend(_currentBookingId!);
    }
  }

  void _showWaitingPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Menunggu Pembayaran",
          style: TextStyle(color: AppColors.gold),
        ),
        content: const Text(
          "Silakan selesaikan pembayaran di browser.\nAplikasi akan otomatis mendeteksi jika berhasil.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _stopPolling();
              Navigator.pop(ctx);
            },
            child: const Text("Tutup", style: TextStyle(color: Colors.grey)),
          ),
        ],
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

  // --- UI UTAMA (TAMPILAN LENGKAP) ---
  @override
  Widget build(BuildContext context) {
    final biaya = widget.rincianBiaya;
    final total = biaya['estimasi_total'] ?? 0;

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
            Container(
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
            ),
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

  Widget _rowBiaya(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            currencyFormatter.format(value),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// --- SCREEN SUKSES (Placeholder) ---
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
                  '/home',
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
