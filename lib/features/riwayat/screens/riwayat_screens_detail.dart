import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/features/profile/widgets/custom_button.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RiwayatDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Provide default values untuk safety dan dukung beberapa variasi struktur respons
    String safeString(dynamic v) => v == null ? '' : v.toString();
    const String placeholderFoto = 'https://via.placeholder.com/150';

    final nama = safeString(
      data['nama'] ??
          data['patient']?['nama'] ??
          data['pasien']?['nama'] ??
          data['user']?['name'],
    );

    final rekamMedis = safeString(
      data['rekam_medis'] ??
          data['no_rekam_medis'] ??
          data['rekamMedis'] ??
          data['patient']?['rekam_medis'],
    );

    final foto = safeString(
      data['foto'] ?? data['patient']?['foto'] ?? data['pasien']?['foto'] ?? '',
    );

    final noPemeriksaan = safeString(
      data['no_pemeriksaan'] ?? data['nomor'] ?? data['id'],
    );

    // tampilkan '-' jika kosong untuk konsistensi UI
    final displayNama = nama.isNotEmpty ? nama : '-';
    final displayRekamMedis = rekamMedis.isNotEmpty ? rekamMedis : '-';
    final displayNoPemeriksaan = noPemeriksaan.isNotEmpty ? noPemeriksaan : '-';

    final jamMulai = safeString(
      data['jam_mulai'] ??
          data['reservasi']?['jam_mulai'] ??
          data['reservasi']?['start_time'] ??
          data['start_time'],
    );
    final jamSelesai = safeString(
      data['jam_selesai'] ??
          data['reservasi']?['jam_selesai'] ??
          data['reservasi']?['end_time'] ??
          data['end_time'],
    );

    final tanggal = safeString(
      data['tanggal'] ?? data['reservasi']?['tanggal'] ?? data['date'],
    );
    final dokter = safeString(
      data['dokter'] ?? data['dokter_nama'] ?? data['doctor'],
    );
    final poli = safeString(
      data['poli'] ?? data['poli_nama'] ?? data['clinic'],
    );

    final status = safeString(
      data['status'] ??
          data['status_reservasi'] ??
          data['reservasi']?['status'],
    );

    final biaya = safeString(
      data['biaya'] ??
          data['reservasi']?['biaya'] ??
          data['total'] ??
          data['harga'] ??
          '0',
    );

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
                  backgroundImage: foto.isNotEmpty && foto != placeholderFoto
                      ? NetworkImage(foto)
                      : null,
                  child: foto.isEmpty || foto == placeholderFoto
                      ? const Icon(Icons.person, color: Colors.grey, size: 35)
                      : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama : $displayNama",
                        style: AppTextStyles.heading.copyWith(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "NO.RM : $displayRekamMedis",
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
                  _buildRowBold("No. Pemeriksaan :", displayNoPemeriksaan),

                  const SizedBox(height: 12),

                  _buildRow("Waktu Layanan", "$jamMulai - $jamSelesai"),
                  _buildRow("Hari/Tanggal", tanggal),
                  _buildRow("Dokter", dokter),
                  _buildRow("Poli", poli),

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
