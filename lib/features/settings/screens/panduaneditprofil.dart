import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class PanduanEditProfilScreen extends StatelessWidget {
  const PanduanEditProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButtonWidget(
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Panduan Edit Profil",
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  "Panduan Aplikasi",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 20,
                    color: AppColors.gold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Panduan Edit Profil",
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),

              const SizedBox(height: 6),

              Text(
                "Jangan khawatir mengubah detail Anda! Data Anda selalu aman dan berada dalam kendali penuh Anda. Kami hanya mencatat perubahan yang Anda konfirmasi.",
                style: AppTextStyles.label.copyWith(fontSize: 13),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStep(
                      number: 1,
                      title: "Akses Menu Profil",
                      description:
                          "Masuk ke aplikasi, kemudian pilih ikon Profil pada navigasi bawah untuk membuka halaman profil utama.",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 2,
                      title: "Masuk ke Menu Profil Saya",
                      description:
                          "Pilih menu Profil Saya untuk melihat informasi pribadi secara lengkap. Data yang tersedia meliputi nomor telepon, email, tanggal lahir, alamat, serta informasi tambahan lainnya (jika ada).",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 3,
                      title: "Edit Profil",
                      description:
                          "Pengguna dapat memperbarui data pribadi dengan memilih tombol Edit Profil. Setelah melakukan perubahan pada data, tekan tombol simpan untuk menyimpan pembaruan tersebut.",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 4,
                      title: "Edit Foto Profil",
                      description:
                          "Untuk mengganti foto profil, pilih menu Edit Foto. Sistem akan menampilkan dua pilihan, yaitu:\n• Pilih dari Galeri — memilih foto dari penyimpanan perangkat\n• Ambil Foto — mengambil gambar baru menggunakan kamera\n• Hapus — menghapus foto profil dan mengembalikannya ke foto default",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required int number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$number.",
          style: AppTextStyles.label.copyWith(
            fontSize: 14,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.input.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.label.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
