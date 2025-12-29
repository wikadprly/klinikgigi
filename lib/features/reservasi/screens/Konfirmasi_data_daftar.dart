import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/providers/reservasi_provider.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/MidTransWebReservasi.dart';
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
  final int total;
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
    required this.total,
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

  @override
  void initState() {
    super.initState();
    keluhanController = TextEditingController(text: widget.keluhan);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context.read<ReservasiProvider>().setKeluhan(widget.keluhan);
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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _checkStatusDiBackend(noPemeriksaan);
    });
  }

  Future<void> _checkStatusDiBackend(String noPemeriksaan) async {
    try {
      final provider = context.read<ReservasiProvider>();
      final statusData = await provider.checkPaymentStatus(noPemeriksaan);

      if (statusData != null) {
        final statusPembayaran = statusData['status_pembayaran'];
        final isLunas = statusData['is_lunas'] ?? false;

        if (isLunas) {
          _stopPolling();
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            _navigateToSuccessScreen(noPemeriksaan);
          }
        }
      }
    } catch (e) {
      debugPrint("Polling error: $e");
    }
  }

  void _stopPolling() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _navigateToSuccessScreen(String noPemeriksaan) async {
    final provider = context.read<ReservasiProvider>();
    final statusData = await provider.checkPaymentStatus(noPemeriksaan);

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
            biaya: widget.total,
            noAntrian: statusData?['no_antrian'],
          ),
        ),
      );
    }
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
          Text(label,
              style: AppTextStyles.label.copyWith(color: Colors.white70)),
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
        Text("Keluhan",
            style: AppTextStyles.label.copyWith(color: Colors.white70)),
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
          Text("Total Pembayaran",
              style: AppTextStyles.label.copyWith(
                color: Colors.white70,
                fontSize: 14,
              )),
          Text(
            "Rp ${widget.total}",
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
              onPressed: provider.isLoading ? null : () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Batal",
                style: TextStyle(color: Colors.white),
              ),
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
                    print("Error parsing rekam_medis_id: $e");
                  }

                  if (rekamMedisId == null || rekamMedisId == 0) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Data rekam medis tidak valid"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    return;
                  }

                  // Prepare user data with fallback values
                  String userName = _currentUser?.namaPengguna?.isNotEmpty == true
                      ? _currentUser!.namaPengguna
                      : widget.namaPasien;
                  String userEmail = _currentUser?.email?.isNotEmpty == true
                      ? _currentUser!.email
                      : 'user@example.com';
                  String userPhone = _currentUser?.noHp?.isNotEmpty == true
                      ? _currentUser!.noHp
                      : '081234567890';

                  // Validate required data before sending
                  if (userName.isEmpty) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
                        const SnackBar(
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
                        const SnackBar(
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
                    'keluhan': keluhanController.text.isNotEmpty ? keluhanController.text : '-', // Ensure keluhan is not empty
                    'metode_pembayaran': 'Midtrans',
                    'jenis_pasien': 'Umum',
                    'user_name': userName,
                    'user_email': userEmail,
                    'user_phone': userPhone,
                  };

                  // Print request data for debugging
                  print("Sending request data: $requestData");

                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator(color: AppColors.gold)),
                  );

                  try {
                    // B. Panggil API create with payment
                    final result = await provider.createReservasiWithPayment(requestData);

                    if (mounted) Navigator.pop(context);

                    print("API Response: $result");

                    // C. Cek Hasil
                    if (result != null && context.mounted) {
                      Navigator.pop(context);

                      final redirectUrl = result['redirect_url'];
                      final noPemeriksaan = result['no_pemeriksaan'];

                      if (redirectUrl != null && noPemeriksaan != null) {
                        _startPollingStatus(noPemeriksaan);
                        final paymentResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MidtransWebReservasi(
                              url: redirectUrl,
                              noPemeriksaan: noPemeriksaan,
                            ),
                          ),
                        );
                        _stopPolling();

                        if (paymentResult == 'success') {
                          final finalStatus = await provider.checkPaymentStatus(noPemeriksaan);
                          if (finalStatus != null && (finalStatus['is_lunas'] ?? false)) {
                            _navigateToSuccessScreen(noPemeriksaan);
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Pembayaran sedang diproses atau gagal."),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          }
                        } else {
                          final finalStatus = await provider.checkPaymentStatus(noPemeriksaan);
                          if (finalStatus != null && (finalStatus['is_lunas'] ?? false)) {
                            _navigateToSuccessScreen(noPemeriksaan);
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'] ?? 'Gagal mendapatkan link pembayaran'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else if (context.mounted) {
                      // E. Error Handling
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorMessage ?? "Gagal melakukan booking"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) Navigator.pop(context); // Close loading dialog
                    print("Error in payment process: $e"); // Debug log
                    if (context.mounted) {
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
                    width: 20, height: 20,
                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                  )
                : !_isUserDataLoaded
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                      )
                    : const Text(
                        "Bayar dengan Midtrans",
                        style: TextStyle(color: Colors.black),
                      ),
            ),
          ),
        )
      ],
    );
  }
}