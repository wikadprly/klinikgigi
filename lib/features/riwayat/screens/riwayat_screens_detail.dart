import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/features/profile/widgets/custom_button.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RiwayatDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Provide default values untuk safety
    final nama = data['nama'] as String? ?? "-";
    final rekamMedis = data['rekam_medis'] as String? ?? "-";
    final foto = data['foto'] as String? ?? "https://via.placeholder.com/150";
    final noPemeriksaan = data['no_pemeriksaan'] as String? ?? "-";
    final jamMulai = data['jam_mulai'] as String? ?? "-";
    final jamSelesai = data['jam_selesai'] as String? ?? "-";
    final tanggal = data['tanggal'] as String? ?? "-";
    final dokter = data['dokter'] as String? ?? "-";
    final poli = data['poli'] as String? ?? "-";
    final catatan = data['catatan'] as String? ?? "-";
    final status =
        data['status'] as String? ?? data['status_reservasi'] as String? ?? "-";
    final biaya = data['biaya'] as String? ?? "0";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text("Detail Riwayat", style: AppTextStyles.heading),
        iconTheme: const IconThemeData(color: AppColors.gold),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== PROFILE PASIEN =====
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.cardDark,
                  backgroundImage:
                      foto.isNotEmpty &&
                          foto != "https://via.placeholder.com/150"
                      ? NetworkImage(foto)
                      : null,
                  child:
                      foto.isEmpty || foto == "https://via.placeholder.com/150"
                      ? const Icon(Icons.person, color: Colors.grey, size: 35)
                      : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama : $nama",
                        style: AppTextStyles.heading.copyWith(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "NO.RM : $rekamMedis",
                        style: AppTextStyles.label.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ===== CARD DETAIL =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gold, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.cardDark,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRowBold("No. Pemeriksaan :", noPemeriksaan),

                  const SizedBox(height: 12),

                  _buildRow("Waktu Layanan", "$jamMulai - $jamSelesai"),
                  _buildRow("Hari/Tanggal", tanggal),
                  _buildRow("Dokter", dokter),
                  _buildRow("Poli", poli),
                  _buildRow("Catatan Dokter", catatan),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Text(
                        "Status Reservasi",
                        style: AppTextStyles.label,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          status,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.input.copyWith(
                            color: (status.toLowerCase() == "selesai")
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TOTAL BIAYA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Biaya :", style: AppTextStyles.label),
                      Text(
                        "Rp.$biaya",
                        style: AppTextStyles.input.copyWith(
                          color: AppColors.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // BUTTON KEMBALI MENGGUNAKAN CUSTOM BUTTON
            CustomButton(
              text: "Kembali",
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // ==== COMPONENT HOLDER ====

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title : ", style: AppTextStyles.label.copyWith(height: 1.4)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.input.copyWith(
                color: AppColors.gold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowBold(String title, String value) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.label.copyWith(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.input.copyWith(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
