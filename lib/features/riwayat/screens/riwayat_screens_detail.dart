import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/profile/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';
import 'dart:async';

class RiwayatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const RiwayatDetailScreen({super.key, required this.data});

  @override
  State<RiwayatDetailScreen> createState() => _RiwayatDetailScreenState();
}

class _RiwayatDetailScreenState extends State<RiwayatDetailScreen> {
  Timer? _timer;
  Duration? _countDownDuration;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    if (widget.data['created_at'] != null) {
      String createdAtStr = widget.data['created_at'].toString();
      DateTime createdAt;

      try {
        createdAt = DateTime.parse(createdAtStr);
      } catch (e) {
        // Jika parsing gagal, gunakan waktu sekarang
        createdAt = DateTime.now();
      }

      DateTime expiryTime = createdAt.add(const Duration(hours: 1));
      Duration difference = expiryTime.difference(DateTime.now());

      if (difference.inSeconds > 0) {
        _countDownDuration = difference;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_countDownDuration!.inSeconds > 0) {
              _countDownDuration = Duration(
                seconds: _countDownDuration!.inSeconds - 1,
              );
            } else {
              _timer?.cancel();
            }
          });
        });
      } else {
        _countDownDuration = Duration.zero;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds <= 0) {
      return 'Waktu habis';
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return '${hours}j ${minutes}m ${seconds}d';
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String clean(dynamic v) {
      if (v == null) return '';
      final s = v.toString().trim();
      if (s.isEmpty) return '';
      if (s == '-' || s.toLowerCase() == 'null') return '';
      return s;
    }

    String pickFirst(List<dynamic> candidates) {
      for (final c in candidates) {
        final s = clean(c);
        if (s.isNotEmpty) return s;
      }
      return '';
    }

    final nama = pickFirst([
      widget.data['nama'],
      widget.data['user']?['nama'],
      widget.data['users']?['nama'],
      widget.data['pasien']?['nama'],
      widget.data['full_reservasi']?['user']?['nama'],
      widget.data['full_reservasi']?['users']?['nama'],
    ]);

    final rekamMedis = pickFirst([
      widget.data['rekam_medis'],
      widget.data['no_rekam_medis'],
      widget.data['no_rm'],
      widget.data['no_rm_pasien'],
      widget.data['pasien']?['rekam_medis'],
      widget.data['pasien']?['no_rekam_medis'],
      widget.data['user']?['rekam_medis'],
      widget.data['user']?['no_rekam_medis'],
    ]);
    final displayNama = nama.isEmpty ? '-' : nama;
    final displayRekamMedis = rekamMedis.isEmpty ? '-' : rekamMedis;
    final noPemeriksaan = clean(widget.data['no_pemeriksaan']);
    final jam =
        "${clean(widget.data['jam_mulai'])} - ${clean(widget.data['jam_selesai'])}";
    final tanggal = clean(widget.data['tanggal']);
    final dokter = clean(widget.data['dokter']);
    final poli = clean(widget.data['poli']);
    final keluhan = clean(widget.data['keluhan'] ?? "Tidak ada keluhan");
    // Normalisasi nama field: support both "status_reservasi" and "statusreservasi"
    final statusReservasi = clean(
      widget.data['status_reservasi'] ??
          widget.data['statusreservasi'] ??
          widget.data['status'] ??
          '',
    );
    final statusPembayaran = clean(
      widget.data['status_pembayaran'] ?? widget.data['status'] ?? '',
    );
    final biaya = clean(widget.data['biaya'] ?? "0");

    Color statusColor1() {
      final s = statusReservasi.toLowerCase().trim();
      switch (s) {
        case 'menunggu':
          return Colors.orange;
        case 'dalam_proses':
        case 'dalam proses':
          return Colors.blue;
        case 'selesai':
          return Colors.green;
        case 'batal':
          return Colors.red;
        default:
          return AppColors.goldDark;
      }
    }

    Color statusColor2() {
      final s = statusPembayaran.toLowerCase().trim();
      switch (s) {
        case 'menunggu_pembayaran':
          return Colors.orange;
        case 'menunggu_verifikasi':
        case 'menunggu verifikasi':
          return Colors.blue;
        case 'terverifikasi':
          return Colors.green;
        case 'gagal':
          return Colors.red;
        default:
          return AppColors.goldDark;
      }
    }

    String displaykeluhan() {
      final v = keluhan.trim();
      if (v.isEmpty || v == '-' || v.toLowerCase() == 'null') {
        return 'Tidak ada keluhan';
      }
      return v;
    }

    // Cari foto prioritas: users.file_foto -> full_reservasi.user.file_foto -> foto -> pasien.file_foto
    String getImageUrl() {
      final u = widget.data['user'];
      if (u != null) {
        final v = u['file_foto'] ?? u['foto'] ?? u['avatar'];
        if (v != null && v.toString().isNotEmpty) return v.toString();
      }

      final full = widget.data['full_reservasi'];
      if (full is Map) {
        final fu = full['user'] ?? full['users'];
        if (fu != null) {
          final v = fu['file_foto'] ?? fu['foto'] ?? fu['avatar'];
          if (v != null && v.toString().isNotEmpty) return v.toString();
        }
      }

      final direct =
          widget.data['foto'] ??
          widget.data['file_foto'] ??
          widget.data['avatar'];
      if (direct != null && direct.toString().isNotEmpty) {
        return direct.toString();
      }

      final pasienFoto =
          widget.data['pasien']?['file_foto'] ?? widget.data['pasien']?['foto'];
      if (pasienFoto != null && pasienFoto.toString().isNotEmpty) {
        return pasienFoto.toString();
      }

      return '';
    }

    final imageUrl = getImageUrl();

    return Consumer<ProfilProvider>(
      builder: (context, profilProvider, child) {
        // Use the profile provider's photo URL as fallback if no image in data
        String finalImageUrl = imageUrl;
        if (finalImageUrl.isEmpty && profilProvider.photoUrl != null && profilProvider.photoUrl!.isNotEmpty) {
          finalImageUrl = profilProvider.photoUrl!;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== JUDUL =====
                const Text("Riwayat", style: AppTextStyles.heading),
                const SizedBox(height: 20),

                // ===== PROFILE PASIEN =====
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: finalImageUrl.isNotEmpty
                          ? NetworkImage(finalImageUrl)
                          : const NetworkImage("https://via.placeholder.com/150"),
                    ),
                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama : $displayNama",
                          style: AppTextStyles.heading.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "NO.RM : $displayRekamMedis",
                          style: AppTextStyles.label,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ===== CARD DETAIL =====
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === TEKS NO PEMERIKSAAN (DALAM PADDING) ===
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "No. Pemeriksaan :",
                              style: AppTextStyles.label.copyWith(fontSize: 13),
                            ),
                            Text(
                              noPemeriksaan,
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.gold,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),

                      // === GARIS FULL TANPA PADDING ===
                      Container(
                        height: 1.8,
                        width: double.infinity,
                        color: AppColors.gold,
                      ),

                      const SizedBox(height: 12),

                      // === DETAIL ITEM LAIN (DAPAT PADDING) ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show different layout for homecare
                            if ((widget.data['jenis_layanan'] ?? '')
                                    .toString()
                                    .toLowerCase() ==
                                'homecare') ...[
                              _item("Hari/Tanggal", tanggal),
                              _item("Waktu Layanan", jam),
                              _item("Dokter", dokter),
                              _item("Layanan", poli),
                              _item("Keluhan", displaykeluhan()),
                              _item(
                                "Status Reservasi",
                                statusReservasi,
                                valueColor: statusColor1(),
                              ),
                              _item(
                                "Status Booking",
                                widget.data['status_booking'] ?? '-',
                                valueColor: statusColor1(),
                              ),
                              _item(
                                "Status Pembayaran",
                                widget.data['status'] ?? '-',
                                valueColor: statusColor2(),
                              ),

                              const SizedBox(height: 15),
                              // ===== DETAIL BIAYA =====
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Biaya',
                                    style: AppTextStyles.label,
                                  ),
                                  Text(
                                    widget.data['pembayaran_total'] ??
                                        widget.data['biaya'] ??
                                        '0',
                                    style: AppTextStyles.heading.copyWith(
                                      color: AppColors.gold,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Biaya Tindakan',
                                    style: AppTextStyles.label,
                                  ),
                                  Text(
                                    widget.data['total_biaya_tindakan'] ?? '0',
                                    style: AppTextStyles.heading.copyWith(
                                      color: AppColors.gold,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              _item("Waktu Layanan", jam),
                              _item("Hari/Tanggal", tanggal),
                              _item("Dokter", dokter),
                              _item("Poli", poli),
                              _item("Keluhan", displaykeluhan()),
                              _item(
                                "Status Reservasi",
                                statusReservasi,
                                valueColor: statusColor1(),
                              ),
                              _item(
                                "Status Pembayaran",
                                statusPembayaran,
                                valueColor: statusColor2(),
                              ),

                              const SizedBox(height: 15),

                              // ===== TOTAL BIAYA =====
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total Biaya :",
                                    style: AppTextStyles.label,
                                  ),
                                  Text(
                                    biaya,
                                    style: AppTextStyles.heading.copyWith(
                                      color: AppColors.gold,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Countdown Timer (hanya muncul jika redirect_url tersedia dan countdown aktif)
                if ((widget.data['redirect_url'] != null &&
                        widget.data['redirect_url'].toString().isNotEmpty) ||
                    (widget.data['link_pembayaran'] != null &&
                        widget.data['link_pembayaran'].toString().isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            _countDownDuration != null &&
                                _countDownDuration!.inSeconds > 0
                            ? Colors.orange.shade100
                            : Colors.red.shade100,
                        border: Border.all(
                          color:
                              _countDownDuration != null &&
                                  _countDownDuration!.inSeconds > 0
                              ? Colors.orange
                              : Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            color:
                                _countDownDuration != null &&
                                    _countDownDuration!.inSeconds > 0
                                ? Colors.orange
                                : Colors.red,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sisa Waktu: ${_formatDuration(_countDownDuration ?? Duration.zero)}',
                            style: TextStyle(
                              color:
                                  _countDownDuration != null &&
                                      _countDownDuration!.inSeconds > 0
                                  ? Colors.orange
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Tombol Pembayaran atau Tombol Dummy (hanya muncul jika redirect_url tersedia)
                if ((widget.data['redirect_url'] != null &&
                        widget.data['redirect_url'].toString().isNotEmpty) ||
                    (widget.data['link_pembayaran'] != null &&
                        widget.data['link_pembayaran'].toString().isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child:
                        _countDownDuration != null &&
                            _countDownDuration!.inSeconds > 0
                        ? CustomButton(
                            text: "Lanjutkan Pembayaran",
                            onPressed: () {
                              String paymentUrl =
                                  widget.data['redirect_url']?.toString() ??
                                  widget.data['link_pembayaran']?.toString() ??
                                  '';
                              if (paymentUrl.isNotEmpty) {
                                _launchURL(paymentUrl);
                              }
                            },
                          )
                        : CustomButton(
                            text: "Waktu Pembayaran Habis",
                            onPressed:
                                null, // Nonaktifkan tombol ketika waktu habis
                            color: Colors
                                .grey, // Warna abu-abu untuk menunjukkan tombol nonaktif
                          ),
                  ),

                // BUTTON KEMBALI
                CustomButton(
                  text: "Kembali",
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==== ITEM DEFAULT =====
  Widget _item(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.label),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.input.copyWith(
              color: valueColor ?? AppColors.gold,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
