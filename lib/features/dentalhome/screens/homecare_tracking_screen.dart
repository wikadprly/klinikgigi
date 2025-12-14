import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/services/home_care_service.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:intl/intl.dart';

class HomeCareTrackingScreen extends StatefulWidget {
  final int bookingId;
  const HomeCareTrackingScreen({super.key, required this.bookingId});

  @override
  State<HomeCareTrackingScreen> createState() => _HomeCareTrackingScreenState();
}

class _HomeCareTrackingScreenState extends State<HomeCareTrackingScreen> {
  final HomeCareService _homeCareService = HomeCareService();

  // State
  String _currentStatus = 'pending';
  String? _paymentStatus;
  String? _settlementStatus; // Separates Booking Fee vs Final Settlement
  int _totalTagihan = 0;
  bool _isLoading = true;
  Timer? _timer;

  // Doctor Info
  String _doctorName = '-';
  String _scheduleDate = '-';
  String _scheduleTime = '-';

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchData(silent: true);
    });
  }

  Future<void> _fetchData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final statusData = await _homeCareService.checkPaymentStatus(
        widget.bookingId,
      );

      if (mounted) {
        setState(() {
          _currentStatus = statusData['status_reservasi'] ?? _currentStatus;
          _paymentStatus = statusData['status_pembayaran'];
          _settlementStatus =
              statusData['status_pelunasan'] ?? 'belum_lunas'; // New Field
          _totalTagihan =
              int.tryParse(statusData['total_biaya_tindakan'].toString()) ?? 0;

          // New Data
          _doctorName = statusData['nama_dokter'] ?? '-';
          _scheduleDate = statusData['jadwal_tanggal'] ?? '-'; // Raw YYYY-MM-DD
          _scheduleTime = statusData['jadwal_jam'] ?? '-';
          // _eta removed

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching tracking data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool get _isReadyForSettlement {
    return _currentStatus == 'menunggu_pelunasan' ||
        _currentStatus == 'selesai_diperiksa';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Darker background per design
      appBar: AppBar(
        title: const Text(
          "Lacak Kunjungan Anda",
          style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Info Card
                  _buildDoctorInfoCard(),

                  const SizedBox(height: 30),

                  // 2. Timeline
                  _buildFixedTimeline(),

                  const SizedBox(height: 40),

                  // 3. Action Buttons
                  // Show button if ready for settlement AND settlement is NOT yet paid (lunas).
                  // Note: _paymentStatus might be 'lunas' for the initial Booking Fee, so we check _settlementStatus here.
                  if (_isReadyForSettlement && _settlementStatus != 'lunas')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/dentalhome/pelunasan',
                            arguments: {
                              'bookingId': widget.bookingId,
                              'totalTagihan': _totalTagihan,
                            },
                          ).then((_) => _fetchData());
                        },
                        child: const Text(
                          "Selesaikan Pembayaran",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.gold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Kembali ke Beranda",
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDoctorInfoCard() {
    // Format Date
    String formattedDate = _scheduleDate;
    try {
      if (_scheduleDate != '-') {
        final date = DateTime.parse(_scheduleDate);
        formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(date);
      }
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ID Kunjungan : #${widget.bookingId}",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            _doctorName,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Jadwal : $formattedDate, $_scheduleTime",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedTimeline() {
    // New Steps:
    // 0: Menunggu Dokter (Assigned, OTW)
    // 1: Pemeriksaan Berlangsung (Sedang Diperiksa)
    // 2: Menunggu Rincian Biaya (Selesai Diperiksa)

    int activeLevel = -1;

    // Status Logic
    int level = _statusLevel(_currentStatus);
    if (level >= 1) activeLevel = 0; // Assigned / OTW
    if (level >= 3) activeLevel = 1; // Diperiksa
    if (level >= 4) activeLevel = 2; // Selesai / Billing

    // REMOVED: if (_paymentStatus == 'lunas') activeLevel = 3;
    // Reason: 'lunas' here refers to the initial booking fee, not the final settlement.
    // The tracking status (status_reservasi) should dictate the flow.

    final steps = [
      {
        'title': 'Menunggu Dokter',
        'desc': 'Dokter $_doctorName akan segera datang.',
        'activeDesc': 'Dokter sedang dalam perjalanan.',
        'icon': Icons.directions_walk,
      },
      {
        'title': 'Pemeriksaan Berlangsung',
        'desc': 'Pemeriksaan belum dimulai.',
        'activeDesc': 'Dokter sedang melakukan pemeriksaan.',
        'icon': Icons.medical_services,
      },
      {
        'title': 'Menunggu Rincian Biaya',
        'desc': 'Tagihan tersedia setelah tindakan selesai.',
        'activeDesc': 'Tagihan siap dibayar.',
        'icon': Icons.receipt_long,
      },
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];

        final isPast = index < activeLevel;
        final isCurrent = index == activeLevel;

        // Colors & Size Logic
        Color color;
        Color iconColor;
        Color borderColor;
        double scale = 1.0;

        if (isPast) {
          // Past: Dimmed (Grey/Gold hint)
          color = Colors.white38;
          iconColor = Colors.grey;
          borderColor = Colors.grey.withOpacity(0.5);
        } else if (isCurrent) {
          // Current: Bright Gold & Zoomed
          color = AppColors.gold;
          iconColor = AppColors.gold;
          borderColor = AppColors.gold;
          scale = 1.15; // Zoom Effect
        } else {
          // Future: Dark Grey
          color = Colors.grey.shade700;
          iconColor = Colors.grey.shade800;
          borderColor = Colors.grey.shade800;
        }

        String desc = (isCurrent && step.containsKey('activeDesc'))
            ? step['activeDesc'] as String
            : step['desc'] as String;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon & Line
              Column(
                children: [
                  AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.gold.withOpacity(0.15)
                            : Colors.transparent,
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                  ),
                  if (index != steps.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        // Line color: Past acts 'done', so use grey. Current line connects to future, so grey.
                        // Actually, users usually like 'filled' progress lines. But if Past color is grey, it implies distinct steps.
                        // Let's keep line simple grey.
                        color: Colors.grey.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: isFuture(index, activeLevel) ? 0.5 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: TextStyle(
                            color: color,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                          child: Text(step['title'] as String),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          desc,
                          style: TextStyle(
                            color: isCurrent ? Colors.white70 : Colors.white24,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  bool isFuture(int index, int activeLevel) => index > activeLevel;

  // Helper Level
  int _statusLevel(String status) {
    // 1: Assigned / Initial State (Menunggu Dokter)
    if ([
      'menunggu', // Default status from DB
      'menunggu_pembayaran',
      'Menunggu Pembayaran', // Fallback from main status column
      'menunggu_dokter',
      'terverifikasi',
      'menunggu_konfirmasi', // Add capitalization variants just in case
      'Menunggu Konfirmasi',
    ].contains(status))
      return 1;
    // 2: OTW
    if (['otw_lokasi', 'dokter_menuju_lokasi'].contains(status)) return 2;
    // 3: In Progress
    if (['sedang_diperiksa', 'dalam_pemeriksaan'].contains(status)) return 3;
    // 4: Billing / Done
    if ([
      'selesai_diperiksa',
      'menunggu_pelunasan',
      'menunggu_pembayaran_obat',
    ].contains(status))
      return 4;
    // 5: Lunas
    if (['lunas'].contains(status)) return 5;

    return 0; // Default pending
  }
}
