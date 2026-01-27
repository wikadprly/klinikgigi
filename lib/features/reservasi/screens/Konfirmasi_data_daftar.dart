import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/providers/reservasi_provider.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/tampilan_akhir_reservasi_midtrans.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:provider/provider.dart';

class KonfirmasiReservasiSheet extends StatefulWidget {
  final String namaPasien;
  final String rekamMedis;
  final String poli;
  final String dokter;
  final String tanggal;
  final String jam;
  final String keluhan;
  final int? total; // Changed to nullable to allow fetching from backend
  final int jadwalId;
  final String dokterId;

  const KonfirmasiReservasiSheet({
    super.key,
    required this.namaPasien,
    required this.rekamMedis,
    required this.poli,
    required this.dokter,
    required this.tanggal,
    required this.jam,
    required this.keluhan,
    this.total, // Made optional
    required this.jadwalId,
    required this.dokterId,
  });

  @override
  State<KonfirmasiReservasiSheet> createState() =>
      _KonfirmasiReservasiSheetState();
}

class _KonfirmasiReservasiSheetState extends State<KonfirmasiReservasiSheet> {
  late TextEditingController keluhanController;
  Timer? _timer;
  UserModel? _currentUser;
  bool _isUserDataLoaded = false;
  int _pollingAttempts = 0; // ✅ TRACKING polling attempts
  static const int MAX_POLLING_ATTEMPTS = 120; // ✅ Max 10 menit (120 * 5 detik)
  int _reservationFee = 25000; // Default value
  bool _isLoadingFee = true; // Track loading state

  @override
  void initState() {
    super.initState();
    keluhanController = TextEditingController(text: widget.keluhan);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context.read<ReservasiProvider>().setKeluhan(widget.keluhan);

        // Fetch reservation fee from backend
        final provider = context.read<ReservasiProvider>();
        final fee = await provider.getReservationFee();
        if (mounted) {
          setState(() {
            _reservationFee = fee;
            _isLoadingFee = false;
          });
        }

        final user = await SharedPrefsHelper.getUser();
        if (user != null && mounted) {
          setState(() {
            _currentUser = user;
            _isUserDataLoaded = true;
          });
        } else {
          setState(() {
            _isUserDataLoaded = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    keluhanController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // --- LOGIKA POLLING STATUS ---
  void _startPollingStatus(String noPemeriksaan) {
    _pollingAttempts = 0; // ✅ Reset counter
    debugPrint("✅ POLLING DIMULAI untuk $noPemeriksaan");
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _pollingAttempts++;
      debugPrint("📍 Polling attempt #$_pollingAttempts ...");

      // ✅ Timeout fallback: Jika polling > 10 menit, stop
      if (_pollingAttempts >= MAX_POLLING_ATTEMPTS) {
        debugPrint(
          "⏱️  POLLING TIMEOUT - Stop polling setelah ${_pollingAttempts * 5} detik",
        );
        _stopPolling();
        if (mounted) {
          // Close the waiting dialog if it's still open
          Navigator.of(context).pop(); // Close the waiting dialog

          // Show timeout message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Timeout: Silakan cek status pembayaran secara manual di menu riwayat.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
        return;
      }

      await _checkStatusDiBackend(noPemeriksaan);
    });
  }

  Future<void> _checkStatusDiBackend(String noPemeriksaan) async {
    try {
      if (!mounted) return;

      final provider = context.read<ReservasiProvider>();
      final statusData = await provider.checkPaymentStatus(noPemeriksaan);

      debugPrint("🔍 STATUS DATA DITERIMA: $statusData");

      if (statusData != null) {
        final statusPembayaran = statusData['status_pembayaran'];
        final isLunas = statusData['is_lunas'] ?? false;

        debugPrint("📊 Status: $statusPembayaran | Is Lunas: $isLunas");

        if (isLunas) {
          debugPrint(
            "✅ PEMBAYARAN BERHASIL TERDETEKSI! (attempt #$_pollingAttempts)",
          );
          _stopPolling();

          if (mounted) {
            // Close the waiting dialog if it's still open
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Close the waiting dialog
            }

            // Navigate to success screen
            _navigateToSuccessScreen(noPemeriksaan);
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Polling error: $e");
    }
  }

  void _stopPolling() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _showWaitingPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            "Menunggu Pembayaran",
            style: TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: AppColors.gold),
              const SizedBox(height: 20),
              const Text(
                "Halaman pembayaran Midtrans telah dibuka di browser.\n\nSilakan lakukan pembayaran, kemudian aplikasi akan otomatis kembali.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Cancel polling and close dialog
                _stopPolling();

                // Pop all dialogs
                if (Navigator.canPop(ctx)) {
                  Navigator.of(ctx).pop();
                }

                // Show cancellation message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Pembayaran dibatalkan."),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text(
                "Batalkan",
                style: TextStyle(color: AppColors.gold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSuccessScreen(String noPemeriksaan) async {
    try {
      if (!mounted) return;

      final provider = context.read<ReservasiProvider>();

      // Get the latest status data to ensure we have the most current info
      final statusData = await provider.checkPaymentStatus(noPemeriksaan);

      if (!mounted) return;

      final statusPembayaran = _mapStatusPembayaran(
        statusData?['status_pembayaran'] ?? '',
      );

      debugPrint("🚀 Navigate ke success: $statusPembayaran");

      // Reset state setelah pembayaran berhasil
      // Ini akan membersihkan pilihan jadwal, dokter, tanggal, dll
      provider.clearData();

      // Navigate to success screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TampilanAkhirReservasiMidtrans(
              noPemeriksaan: noPemeriksaan,
              nama: widget.namaPasien,
              dokter: widget.dokter,
              poli: widget.poli,
              tanggal: widget.tanggal,
              jam: widget.jam,
              keluhan: widget.keluhan,
              biaya: widget.total ?? _reservationFee,
              noAntrian: statusData?['no_antrian'],
              statusPembayaran: statusPembayaran,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error navigate: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menuju halaman sukses: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ HELPER: Map status database ke display text
  String _mapStatusPembayaran(String statusDb) {
    return switch (statusDb) {
      'lunas' => '✅ Lunas',
      'terverifikasi' => '✅ Terverifikasi',
      'menunggu_pembayaran' => '⏳ Menunggu Pembayaran',
      'menunggu_verifikasi' => '⏳ Menunggu Verifikasi',
      'gagal' => '❌ Gagal',
      _ => 'Lunas',
    };
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservasiProvider>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 25),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dragHandle(),
            const SizedBox(height: 5),
            _titleSection(),
            const SizedBox(height: 20),
            _buildCardSection(),
            const SizedBox(height: 18),
            _keluhanField(provider),
            const SizedBox(height: 22),
            _totalBox(),
            const SizedBox(height: 25),
            _actionButtons(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _dragHandle() {
    return Center(
      child: Container(
        width: 45,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _titleSection() {
    return Text(
      "Konfirmasi Data Pendaftaran",
      style: AppTextStyles.heading.copyWith(
        color: AppColors.gold,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildCardSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoItem("Nama Lengkap", widget.namaPasien),
          _infoItem("No. Rekam Medis", widget.rekamMedis),
          _infoItem("Poli", widget.poli),
          _infoItem("Dokter", widget.dokter),
          _infoItem("Tanggal", widget.tanggal),
          _infoItem("Waktu Layanan", widget.jam),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTextStyles.input.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _keluhanField(ReservasiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Keluhan",
          style: AppTextStyles.label.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.goldDark, width: 1),
            color: AppColors.cardDark,
          ),
          child: TextField(
            controller: keluhanController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12),
              border: InputBorder.none,
              hintText: "Tuliskan keluhan Anda...",
              hintStyle: TextStyle(color: Colors.white38),
            ),
            onChanged: provider.setKeluhan,
          ),
        ),
      ],
    );
  }

  Widget _totalBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.goldDark),
        borderRadius: BorderRadius.circular(14),
        color: AppColors.cardDark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Pembayaran",
            style: AppTextStyles.label.copyWith(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          _isLoadingFee
              ? const SizedBox(
                  width: 60,
                  height: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.gold,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Text(
                  "Rp ${widget.total ?? _reservationFee}",
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context, ReservasiProvider provider) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              // Disable tombol Batal kalau lagi loading
              onPressed: provider.isLoading
                  ? null
                  : () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text("Batal", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              // Logic Tombol Bayar
              onPressed: provider.isLoading || !_isUserDataLoaded
                  ? null
                  : () async {
                      // Prevent multiple clicks
                      if (provider.isLoading) return;

                      int? rekamMedisId;
                      try {
                        rekamMedisId = int.tryParse(widget.rekamMedis);
                        if (rekamMedisId == null) {
                          RegExp regExp = RegExp(r'(\d+)$');
                          Match? match = regExp.firstMatch(widget.rekamMedis);
                          if (match != null) {
                            rekamMedisId = int.tryParse(match.group(1)!) ?? 0;
                          }
                        }
                      } catch (e) {
                        debugPrint("Error parsing rekam_medis_id: $e");
                      }

                      if (rekamMedisId == null || rekamMedisId == 0) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Data rekam medis tidak valid"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        return;
                      }

                      // Prepare user data with fallback values
                      String userName =
                          _currentUser?.namaPengguna.isNotEmpty == true
                          ? _currentUser!.namaPengguna
                          : widget.namaPasien;
                      String userEmail = _currentUser?.email.isNotEmpty == true
                          ? _currentUser!.email
                          : 'user@example.com';
                      String userPhone = _currentUser?.noHp.isNotEmpty == true
                          ? _currentUser!.noHp
                          : '081234567890';

                      // Validate required data before sending
                      if (userName.isEmpty) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Nama pengguna tidak valid"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        return;
                      }

                      if (userEmail.isEmpty || !userEmail.contains('@')) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email tidak valid"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        return;
                      }

                      if (userPhone.isEmpty) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Nomor telepon tidak valid"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        return;
                      }

                      final requestData = {
                        'rekam_medis_id': rekamMedisId,
                        'dokter_id': widget.dokterId,
                        'jadwal_id': widget.jadwalId,
                        'tanggal_pesan': widget.tanggal,
                        'keluhan': keluhanController.text.isNotEmpty
                            ? keluhanController.text
                            : '-', // Ensure keluhan is not empty
                        'metode_pembayaran': 'Midtrans',
                        'jenis_pasien': 'Umum',
                        'user_name': userName,
                        'user_email': userEmail,
                        'user_phone': userPhone,
                      };

                      // Print request data for debugging
                      debugPrint("Sending request data: $requestData");

                      try {
                        // Show loading indicator
                        if (mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.gold,
                              ),
                            ),
                          );
                        }

                        // Call API to create reservation with payment
                        final result = await provider
                            .createReservasiWithPayment(requestData);

                        // Dismiss loading dialog
                        if (mounted) {
                          Navigator.of(context).pop(); // Close loading dialog
                        }

                        debugPrint("API Response: $result");

                        // Check result
                        if (result != null && mounted) {
                          final redirectUrl = result['redirect_url'];
                          final noPemeriksaan = result['no_pemeriksaan'];

                          if (redirectUrl != null && noPemeriksaan != null) {
                            // Start polling for payment status
                            _startPollingStatus(noPemeriksaan);

                            // Open payment page in external browser
                            final uri = Uri.parse(redirectUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );

                              // Show waiting payment dialog
                              _showWaitingPaymentDialog(context);
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Tidak dapat membuka halaman pembayaran',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              _stopPolling();
                            }
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message'] ??
                                        'Gagal mendapatkan link pembayaran',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } else if (mounted) {
                          // Error handling
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                provider.errorMessage ??
                                    "Gagal melakukan booking",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        // Dismiss loading dialog if still open
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop(); // Close loading dialog
                        }

                        debugPrint("Error in payment process: $e"); // Debug log
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : !_isUserDataLoaded
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Bayar",
                      style: TextStyle(color: Colors.black),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
