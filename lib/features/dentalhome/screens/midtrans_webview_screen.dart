import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import khusus Android agar tidak error di beberapa device
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../../../theme/colors.dart'; // Sesuaikan path theme Anda

class MidtransWebViewScreen extends StatefulWidget {
  final String url;
  final String noPemeriksaan;

  const MidtransWebViewScreen({
    super.key,
    required this.url,
    required this.noPemeriksaan,
  });

  @override
  State<MidtransWebViewScreen> createState() => _MidtransWebViewScreenState();
}

class _MidtransWebViewScreenState extends State<MidtransWebViewScreen> {
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
          // Deteksi jika pembayaran sukses / selesai berdasarkan URL redirect Midtrans
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            // Cek berbagai kemungkinan URL sukses Midtrans
            if (url.contains('status_code=200') ||
                url.contains('transaction_status=settlement') ||
                url.contains('transaction_status=capture') ||
                url.contains('success') ||
                url.contains('/finish') || // Default redirect midtrans
                // Tambahan: Kadang user menekan "Back to Merchant"
                url.contains('example.com')) {
              // Ganti dengan domain callback Anda jika ada

              // Tutup WebView dan kirim sinyal sukses
              Navigator.pop(context, 'success');
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
      appBar: AppBar(
        backgroundColor: AppColors.background, // Sesuaikan tema Dark
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // Tutup WebView
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
              "Order ID: ${widget.noPemeriksaan}", // Menampilkan No Pemeriksaan
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // WebView Widget
          WebViewWidget(controller: _controller),

          // Loading Indicator Custom
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              ),
            ),
        ],
      ),
    );
  }
}
