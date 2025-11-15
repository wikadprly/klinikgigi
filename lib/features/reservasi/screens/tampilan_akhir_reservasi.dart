import 'package:flutter/material.dart';
// Pastikan path ini sudah benar di project Anda
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';

class TampilanAkhirReservasi extends StatelessWidget {
  const TampilanAkhirReservasi({super.key});

  // Helper untuk membuat baris detail
  // Label di kiri, value di kanan. Value di set ke kosong sesuai permintaan
  Widget detailRow({required String label, String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (E.g., No. Pemeriksaan :)
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textLight,
            fontSize: 15.5,
          ),
        ),
        const SizedBox(width: 8), // Memberi sedikit jarak

        // Value - Diisi string kosong agar tampil kosong di awal
        Expanded(
          child: Text(
            value ?? "",
            textAlign: TextAlign.right, // Memastikan value rata kanan
            style: AppTextStyles.input.copyWith(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: AppColors.gold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Pusatkan seluruh konten kolom
              children: [
                const SizedBox(height: 14),

                // Tombol Kembali (Back Button) DIHAPUS SEKARANG

                const SizedBox(
                    height:
                        30), // Mengurangi spasi karena tombol kembali dihapus

                // Checkmark Circle (Ukuran JAUH lebih kecil)
                Container(
                  width: 80, // Lingkaran diperkecil signifikan
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.gold,
                        AppColors.gold.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 40, // Icon centang diperkecil signifikan
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Title "Pendaftaran Berhasil" (Di tengah)
                Text(
                  "Pendaftaran Berhasil",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle/Description (2 baris, di tengah, warna Kuning/Gold)
                Text(
                  "Pendaftaran Anda telah berhasil disimpan.\nSilakan datang sesuai jadwal yang tertera di bawah ini.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(
                      color: AppColors.gold, // Warna Kuning/Gold
                      fontSize: 14.5,
                      height:
                          1.5 // Mengatur tinggi baris agar tidak terlalu rapat
                      ),
                ),

                const SizedBox(height: 35),

                // BOX DETAIL (Tidak Cekung/Non-Rounded, border biasa)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    // Menghilangkan borderRadius agar tidak cekung
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color: AppColors.goldDark,
                      width: 1.8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris 1: No. Pemeriksaan (dengan garis bawah, data kosong di kanan)
                      detailRow(label: "No. Pemeriksaan :"),
                      const Divider(
                          color: AppColors.goldDark,
                          height: 24,
                          thickness: 1), // Garis di bawah

                      // Baris 2 sampai 8 (data kosong di kanan)
                      detailRow(label: "Nama :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Waktu Layanan :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Hari/Tanggal :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Dokter :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Poli :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Keluhan :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Biaya Administrasi :"),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Button
                AuthButton(
                  text: ButtonText.lihatRiwayat,
                  onPressed: () async {
                    // TODO: Tambahkan navigasi ke halaman riwayat di sini
                    debugPrint("Navigate to history page");
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
