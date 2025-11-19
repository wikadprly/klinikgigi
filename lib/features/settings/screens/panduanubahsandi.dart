import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class PanduanUbahSandiScreen extends StatelessWidget {
  const PanduanUbahSandiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView( physics: BouncingScrollPhysics(), child: Padding(
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
                    "Panduan Ubah Sandi",
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
                "Panduan Ubah Sandi",
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),

              const SizedBox(height: 6),

              Text(
                "Anda tidak perlu mengingat-ingat sandi lama! Kami sediakan proses reset sandi yang cepat dan terpandu. Cukup ikuti instruksi yang kami kirim ke email Anda.",
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
                      title: "Buka Menu Profil",
                      description:
                          "Masuk ke halaman utama aplikasi. Tekan ikon Pengaturan / Settings yang biasanya berada di pojok kanan atas. Gulir ke bawah hingga menemukan menu 'Ubah Kata Sandi'.",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 2,
                      title: "Pilih 'Ubah Kata Sandi'",
                      description:
                          "Ketuk tombol 'Ubah Kata Sandi'. Aplikasi akan menampilkan halaman untuk memulai proses verifikasi keamanan.",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 3,
                      title: "Masukkan Kata Sandi Saat Ini",
                      description:
                          "Pada halaman pertama, masukkan kata sandi lama kamu. Pastikan huruf besar–kecil, angka, dan simbol sesuai dengan kata sandi yang kamu pakai sebelumnya. Tekan tombol 'Lanjutkan'.",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 4,
                      title: "Verifikasi Identitas Melalui OTP Email",
                      description:
                          "Setelah menekan lanjut, sistem akan mengirim kode OTP (One-Time Password) ke email yang terdaftar. Buka kotak masuk email kamu dan salin 6 digit kode tersebut. Ketik kode verifikasi pada kolom yang tersedia lalu tekan 'Verifikasi'.",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 5,
                      title: "Masukkan Kata Sandi Baru",
                      description:
                          "Setelah OTP berhasil diverifikasi, masukkan kata sandi baru di kolom 'Kata Sandi Baru'. Masukkan ulang di kolom 'Konfirmasi Kata Sandi'. Pastikan kata sandi baru: \n• Minimal 8 karakter,\n• Memiliki huruf besar & kecil,\n• Mengandung angka,\n• Mengandung simbol disarankan,\n• Tidak sama dengan kata sandi lama.",
                    ),
                    const SizedBox(height: 14),
                    _buildStep(
                      number: 6,
                      title: "Kata Sandi Berhasil Diperbarui",
                      description:
                          "Jika semua langkah benar, aplikasi akan menampilkan pesan: 'Kata sandi berhasil diperbarui'. Silakan masuk kembali dengan kata sandi terbaru Anda.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
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
