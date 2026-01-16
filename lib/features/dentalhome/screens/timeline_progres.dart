import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart'; // Sesuaikan path ini jika berbeda

/// Widget yang bertanggung jawab hanya untuk menampilkan progress timeline
/// berdasarkan status yang diterima dari HomeCareTrackingScreen.
class TimelineProgresModule extends StatelessWidget {
  final String currentStatus;
  final String doctorName;

  const TimelineProgresModule({
    super.key,
    required this.currentStatus,
    required this.doctorName,
  });

  // Helper Level (Dipindahkan dari HomeCareTrackingScreenState)
  int _statusLevel(String status) {
    // 1: Assigned / Initial State (Menunggu Dokter)
    if ([
      'menunggu', // Default status from DB
      'menunggu_pembayaran',
      'Menunggu Pembayaran', // Fallback from main status column
      'menunggu_dokter',
      'terverifikasi',
      'menunggu_konfirmasi',
      'Menunggu Konfirmasi',
      'Menunggu Konfirmasi Admin', // New
    ].contains(status)) {
      return 1;
    }
    // 2: OTW
    if (['otw_lokasi', 'dokter_menuju_lokasi', 'Dokter Sedang Menuju Lokasi'].contains(status)) return 2;
    // 3: In Progress
    if (['sedang_diperiksa', 'dalam_pemeriksaan', 'Sedang Dalam Pemeriksaan'].contains(status)) return 3;
    // 4: Billing / Done
    if ([
      'selesai_diperiksa',
      'menunggu_pelunasan',
      'menunggu_pembayaran_obat',
      'Pemeriksaan Selesai (Menunggu Pembayaran)', // New
    ].contains(status)) {
      return 4;
    }
    // 5: Lunas
    if (['lunas', 'Layanan Selesai & Lunas'].contains(status)) return 5;

    return 0; // Default pending
  }

  bool _isFuture(int index, int activeLevel) => index > activeLevel;

  @override
  Widget build(BuildContext context) {
    // New Steps:
    // 0: Menunggu Dokter (Assigned, OTW) -> Level 1 & 2
    // 1: Pemeriksaan Berlangsung (Sedang Diperiksa) -> Level 3
    // 2: Menunggu Rincian Biaya (Selesai Diperiksa) -> Level 4

    int activeLevel = -1;

    // Status Logic
    int level = _statusLevel(currentStatus);
    if (level >= 1) activeLevel = 0; // Assigned / OTW
    if (level >= 3) activeLevel = 1; // Diperiksa
    if (level >= 4) activeLevel = 2; // Selesai / Billing

    final steps = [
      {
        'title': 'Menunggu Dokter',
        'desc': 'Dokter $doctorName akan segera datang.',
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
                    opacity: _isFuture(index, activeLevel) ? 0.5 : 1.0,
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
}