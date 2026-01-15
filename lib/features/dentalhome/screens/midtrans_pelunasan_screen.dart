import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_klinik_gigi/core/models/nota_model.dart';
import 'package:flutter_klinik_gigi/core/services/home_care_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

import 'midtrans_webview_screen.dart';
import 'pembayaran_berhasil_pelunasan.dart';

class MidtransPelunasanScreen extends StatefulWidget {
  final int bookingId;
  final int totalTagihan;

  const MidtransPelunasanScreen({
    super.key,
    required this.bookingId,
    required this.totalTagihan,
  });

  @override
  State<MidtransPelunasanScreen> createState() =>
      _MidtransPelunasanScreenState();
}

class _MidtransPelunasanScreenState extends State<MidtransPelunasanScreen> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  late final HomeCareService _homeCareService;

  // State
  int _userPoints = 0;
  String _userName = "Pasien"; // Default
  List<Map<String, dynamic>> _availablePromos = [];
  Map<String, dynamic>? _selectedPromo;
  bool _isLoadingPromos = false;
  bool _isProcessing = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _homeCareService = HomeCareService();
    _fetchUserPoints();
    _fetchPromos();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserPoints() async {
    final user = await SharedPrefsHelper.getUser();
    if (user != null) {
      final points = await _homeCareService.getUserPoints(user.userId);
      if (mounted) {
        setState(() {
          _userPoints = points;
          _userName = user.namaPengguna;
        });
      }
    }
  }

  Future<void> _fetchPromos() async {
    setState(() => _isLoadingPromos = true);
    try {
      final user = await SharedPrefsHelper.getUser();
      final promos = await _homeCareService.getPromos(
        type: 'settlement',
        userId: user?.userId,
      );
      if (mounted) setState(() => _availablePromos = promos);
    } catch (e) {
      // Ignore
    } finally {
      if (mounted) setState(() => _isLoadingPromos = false);
    }
  }

  Future<void> _processSettlement() async {
    setState(() => _isProcessing = true);
    try {
      final result = await _homeCareService.createSettlement(
        widget.bookingId,
        promoId: _selectedPromo?['id'],
      );

      final redirectUrl = result['redirect_url'];

      if (redirectUrl != null) {
        bool isDesktop =
            kIsWeb ||
            Platform.isWindows ||
            Platform.isLinux ||
            Platform.isMacOS;

        if (isDesktop) {
          final uri = Uri.parse(redirectUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            _showPaymentConfirmationDialog();
          } else {
            _showSnackbar('Tidak dapat membuka link pembayaran', isError: true);
          }
        } else {
          // Mobile: Use WebView
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MidtransWebViewScreen(
                url: redirectUrl,
                noPemeriksaan: 'PELUNASAN-${widget.bookingId}',
              ),
            ),
          );
          // After return from WebView, check status
          _checkPaymentStatus();
        }
      } else {
        _showSnackbar('Gagal mendapatkan link pembayaran', isError: true);
      }
    } catch (e) {
      _showSnackbar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _checkPaymentStatus() async {
    try {
      debugPrint(
        "MidtransPelunasan: Checking payment status for Booking ${widget.bookingId}",
      );
      final statusData = await _homeCareService.checkPaymentStatus(
        widget.bookingId,
      );
      debugPrint("MidtransPelunasan: Status Data Received: $statusData");

      // PENTING: Cek status_pelunasan
      final statusPelunasan = statusData['status_pelunasan'];

      if (statusPelunasan == 'lunas' ||
          statusPelunasan == 'settlement' ||
          statusPelunasan == 'success') {
        _pollingTimer?.cancel(); // Stop polling if successful

        // Construct Invoice
        final invoice = InvoiceModel(
          invoiceId: "INV-PL-${widget.bookingId}",
          namaPasien: _userName,
          tanggal: DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
          items: [
            InvoiceItem(nama: "Pelunasan HomeCare", harga: widget.totalTagihan),
          ],
          subtotal: widget.totalTagihan,
          booking: 0,
          totalAkhir: widget.totalTagihan,
        );

        if (mounted) {
          // Close dialog if open (check if route is dialog) - simplistically just pop
          // But safer to just navigate away
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => PembayaranBerhasilScreen(invoice: invoice),
            ),
            (route) => false, // Clear stack
          );
        }
      } else {
        // Just continue polling or show message
      }
    } catch (e) {
      // Ignore
    }
  }

  void _showPaymentConfirmationDialog() {
    // Start Polling
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _checkPaymentStatus();
      } else {
        timer.cancel();
      }
    });

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
                "Silakan selesaikan pembayaran di browser Anda.\nAplikasi akan otomatis mengecek status pembayaran.",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                color: AppColors.gold,
                backgroundColor: Colors.white10,
              ),
              SizedBox(height: 10),
              Text(
                "Mengecek otomatis setiap 5 detik...",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [],
        ),
      ),
    ).then((_) {
      _pollingTimer?.cancel();
    });
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message),
      ),
    );
  }

  void _showPromoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pilih Promo Pelunasan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Poin Anda: $_userPoints",
                style: const TextStyle(color: AppColors.gold),
              ),
              const SizedBox(height: 20),
              if (_isLoadingPromos)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  ),
                ),
              if (!_isLoadingPromos && _availablePromos.isEmpty)
                const Center(
                  child: Text(
                    "Tidak ada promo tersedia",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

              ..._availablePromos.map((promo) {
                final hargaPoin = promo['harga_poin'] ?? 0;
                final bool canRedeem = _userPoints >= hargaPoin;

                return Card(
                  color: Colors.white10,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      promo['judul_promo'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "${promo['deskripsi']}\n-$hargaPoin Poin",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canRedeem
                            ? AppColors.gold
                            : Colors.grey,
                      ),
                      onPressed: canRedeem
                          ? () {
                              setState(() => _selectedPromo = promo);
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text(
                        "Gunakan",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calc Total
    int discount = 0;
    if (_selectedPromo != null) {
      final dynamic rawNilaiPotongan = _selectedPromo!['nilai_potongan'];
      if (rawNilaiPotongan != null) {
        if (rawNilaiPotongan is num) {
          discount = rawNilaiPotongan.toInt();
        } else if (rawNilaiPotongan is String) {
          // Parse as double first since API returns "20000.00" format
          discount = double.tryParse(rawNilaiPotongan)?.toInt() ?? 0;
        }
      }
    }

    int finalTotal = widget.totalTagihan - discount;
    if (finalTotal < 0) finalTotal = 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text(
          "Pelunasan Tindakan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Bill Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C), // Darker card background
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Total Tagihan Tindakan",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(widget.totalTagihan),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 40),

                  // Promo Selection
                  InkWell(
                    onTap: _showPromoModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_activity, // Ticket icon
                            color: _selectedPromo != null
                                ? AppColors.gold
                                : Colors.white54,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedPromo != null
                                      ? "Promo Terpasang"
                                      : "Makin hemat pakai promo",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_selectedPromo == null)
                                  const Text(
                                    "Klik untuk melihat promo tersedia",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_selectedPromo != null)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () =>
                                  setState(() => _selectedPromo = null),
                            )
                          else
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white54,
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Details
                  if (_selectedPromo != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Diskon Promo",
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          "- ${currencyFormatter.format(discount)}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Bayar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        currencyFormatter.format(finalTotal),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2C),
            border: Border(top: BorderSide(color: Colors.white10)),
          ),
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processSettlement,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : Text(
                    "Bayar Sekarang (${currencyFormatter.format(finalTotal)})",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
