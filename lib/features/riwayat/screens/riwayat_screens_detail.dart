import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/profile/widgets/custom_button.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RiwayatDetailScreen({super.key, required this.data});

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
      data['nama'],
      data['user']?['nama'],
      data['users']?['nama'],
      data['pasien']?['nama'],
      data['full_reservasi']?['user']?['nama'],
      data['full_reservasi']?['users']?['nama'],
    ]);

    final rekamMedis = pickFirst([
      data['rekam_medis'],
      data['no_rekam_medis'],
      data['no_rm'],
      data['no_rm_pasien'],
      data['pasien']?['rekam_medis'],
      data['pasien']?['no_rekam_medis'],
      data['user']?['rekam_medis'],
      data['user']?['no_rekam_medis'],
    ]);
    final displayNama = nama.isEmpty ? '-' : nama;
    final displayRekamMedis = rekamMedis.isEmpty ? '-' : rekamMedis;
    final noPemeriksaan = clean(data['no_pemeriksaan']);
    final jam = "${clean(data['jam_mulai'])} - ${clean(data['jam_selesai'])}";
    final tanggal = clean(data['tanggal']);
    final dokter = clean(data['dokter']);
    final poli = clean(data['poli']);
    final keluhan = clean(data['keluhan'] ?? "Tidak ada keluhan");
    // Normalisasi nama field: support both "status_reservasi" and "statusreservasi"
    final statusReservasi = clean(
      data['status_reservasi'] ??
          data['statusreservasi'] ??
          data['status'] ??
          '',
    );
    final statusPembayaran = clean(
      data['status_pembayaran'] ?? data['status'] ?? '',
    );
    final biaya = clean(data['biaya'] ?? "0");

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
      final u = data['user'];
      if (u != null) {
        final v = u['file_foto'] ?? u['foto'] ?? u['avatar'];
        if (v != null && v.toString().isNotEmpty) return v.toString();
      }

      final full = data['full_reservasi'];
      if (full is Map) {
        final fu = full['user'] ?? full['users'];
        if (fu != null) {
          final v = fu['file_foto'] ?? fu['foto'] ?? fu['avatar'];
          if (v != null && v.toString().isNotEmpty) return v.toString();
        }
      }

      final direct = data['foto'] ?? data['file_foto'] ?? data['avatar'];
      if (direct != null && direct.toString().isNotEmpty) {
        return direct.toString();
      }

      final pasienFoto =
          data['pasien']?['file_foto'] ?? data['pasien']?['foto'];
      if (pasienFoto != null && pasienFoto.toString().isNotEmpty) {
        return pasienFoto.toString();
      }

      return '';
    }

    final imageUrl = getImageUrl();

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
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
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
                          style: AppTextStyles.label.copyWith(fontSize: 14),
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
                        if ((data['jenis_layanan'] ?? '')
                                .toString()
                                .toLowerCase() ==
                            'homecare') ...[
                          _item("Hari/Tanggal", tanggal),
                          _item("Waktu Layanan", jam),
                          _item("Dokter", dokter),
                          _item("Poli", poli),
                          _item("Keluhan", displaykeluhan()),
                          _item(
                            "Status Reservasi",
                            statusReservasi,
                            valueColor: statusColor1(),
                          ),
                          _item(
                            "Status Booking",
                            data['status_booking'] ?? '-',
                            valueColor: statusColor1(),
                          ),
                          _item(
                            "Status Pembayaran",
                            data['status'] ?? '-',
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
                                data['pembayaran_total'] ?? data['biaya'] ?? '0',
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
                                data['total_biaya_tindakan'] ?? '0',
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

            // BUTTON KEMBALI
            CustomButton(
              text: "Kembali",
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
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
