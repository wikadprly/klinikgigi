import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart'; // Sesuaikan path theme Anda

class MidtransWebReservasi extends StatefulWidget {
  final String url;
  final String noPemeriksaan; // Parameter Wajib

  const MidtransWebReservasi({
    super.key,
    required this.url,
    required this.noPemeriksaan,
  });

  @override
  State<MidtransWebReservasi> createState() => _MidtransWebReservasiState();
}

class _MidtransWebReservasiState extends State<MidtransWebReservasi> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // --- 1. INISIALISASI KHUSUS ANDROID (SOLUSI LAYAR MERAH) ---
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // ---------------------------------------------------------

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
          },
          // --- 2. DETEKSI REDIRECT / SUKSES ---
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            // Logika Deteksi Sukses Midtrans
            // Menyesuaikan pola URL redirect dari Midtrans Snap
            if (url.contains('status_code=200') ||
                url.contains('transaction_status=settlement') ||
                url.contains('transaction_status=capture') ||
                url.contains('success') ||
                url.contains('/finish') || // Default redirect midtrans
                url.contains('example.com') // Ganti dengan domain callback kamu jika ada
               ) {
              
              // Tutup WebView dan kirim sinyal 'success' ke halaman sebelumnya
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }
            
            // Jika user klik "Back to Merchant" tapi status belum jelas (pending)
            if (url.contains('status_code=201') || url.contains('pending')) {
               Navigator.pop(context, 'pending');
               return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // Tutup WebView (User membatalkan atau selesai manual)
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pembayaran",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Order ID: ${widget.noPemeriksaan}", 
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // WebView Widget
          WebViewWidget(controller: _controller),

          // Loading Indicator Custom (Biar user tau lagi loading)
          if (isLoading)
            Container(
              color: AppColors.background, // Background gelap saat loading awal
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              ),
            ),
        ],
      ),
    );
  }
}