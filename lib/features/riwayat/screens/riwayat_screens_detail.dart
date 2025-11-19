import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/profile/widgets/custom_button.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RiwayatDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String safe(dynamic v) => v == null ? '' : v.toString();

    final nama = safe(data['nama'] ?? data['pasien']?['nama']);
    final rekamMedis = safe(data['rekam_medis']);
    final noPemeriksaan = safe(data['no_pemeriksaan']);
    final jam = "${safe(data['jam_mulai'])} - ${safe(data['jam_selesai'])}";
    final tanggal = safe(data['tanggal']);
    final dokter = safe(data['dokter']);
    final poli = safe(data['poli']);
    final catatan = safe(data['catatan'] ?? "Tidak ada catatan");
    final status = safe(data['status']);
    final biaya = safe(data['biaya'] ?? "0");

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== JUDUL =====
            const Text(
              "Riwayat",
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 20),

            // ===== PROFILE PASIEN =====
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    "https://via.placeholder.com/150",
                  ),
                ),
                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama : $nama",
                      style: AppTextStyles.heading.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "NO.RM : $rekamMedis",
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                        _item("Waktu Layanan", jam),
                        _item("Hari/Tanggal", tanggal),
                        _item("Dokter", dokter),
                        _item("Poli", poli),
                        _item("Catatan Dokter", catatan),

                        _item(
                          "Status Reservasi",
                          status,
                          valueColor: Colors.greenAccent,
                        ),

                        const SizedBox(height: 15),

                        // ===== TOTAL BIAYA =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Biaya :", style: AppTextStyles.label),
                            Text(
                              "Rp.$biaya",
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.gold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

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
          const SizedBox(height: 3),
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
