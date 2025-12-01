import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class PanduanHomeDentalCarePage extends StatelessWidget {
  const PanduanHomeDentalCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: back button + title
              Row(
                children: [
                  BackButtonWidget(onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 14),
                  Text(
                    "Panduan Aplikasi",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.gold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page main title
                      Text(
                        "Panduan Home Dental Care",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.gold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Intro paragraph
                      Text(
                        "Lupakan rutinitas yang rumit. Kami hadirkan panduan Home Dental Care yang simpel dan anti-ribet. Anda pasti bisa melakukannya!",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textLight,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Big bordered guide card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.gold, width: 1),
                          color: AppColors.cardDark, // agar kontras sedikit
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _guideStep(
                              number: 1,
                              title: "Login / Verifikasi Akun",
                              description:
                                  "Pengguna wajib masuk (login) ke aplikasi menggunakan akun yang telah terdaftar untuk dapat mengakses seluruh fitur layanan.",
                            ),
                            const SizedBox(height: 12),
                            _guideStep(
                              number: 2,
                              title: "Pemilihan Jadwal Kunjungan",
                              description:
                                  "Pengguna dapat memilih jadwal kunjungan dengan menentukan tanggal yang diinginkan. Setelah tanggal dipilih, sistem akan otomatis menampilkan daftar dokter yang tersedia. Pengguna dapat memilih dokter, lalu menekan tombol Konfirmasi Jadwal untuk melanjutkan ke tahap berikutnya.",
                            ),
                            const SizedBox(height: 12),
                            _guideStep(
                              number: 3,
                              title: "Pengisian Lokasi",
                              description:
                                  "Pengguna dapat menggunakan lokasi saat ini atau memasukkan lokasi alamat rumah secara manual. Pengguna juga dapat menambahkan detail tambahan seperti Blok/No. Rumah pada kolom yang tersedia. Sistem kemudian akan menampilkan estimasi jarak dan biaya berdasarkan jarak antara alamat pengguna dan klinik.",
                            ),
                            const SizedBox(height: 12),
                            _guideStep(
                              number: 4,
                              title: "Pembayaran Booking Awal",
                              description:
                                  "Pengguna dapat melihat rincian biaya awal sebelum melakukan pembayaran. Proses pembayaran dapat dilakukan melalui metode BCA Virtual Account, GoPay, atau ShopeePay. Setelah pembayaran berhasil, sistem akan menampilkan notifikasi Transaksi Berhasil sebagai bukti bahwa pembayaran telah diproses.",
                            ),
                            const SizedBox(height: 12),
                            _guideStep(
                              number: 5,
                              title: "Pelacakan Kunjungan (Tracking)",
                              description:
                                  "Pengguna dapat memantau progres kunjungan melalui tampilan timeline, mulai dari penugasan dokter, perjalanan dokter menuju lokasi, proses pemeriksaan, hingga rincian biaya akhir. Setelah pemeriksaan selesai, pengguna dapat menekan tombol Selesaikan Pembayaran untuk melanjutkan ke pembayaran akhir.",
                            ),
                            const SizedBox(height: 12),
                            _guideStep(
                              number: 6,
                              title: "Rincian Tagihan Akhir & Penyelesaian Pembayaran",
                              description:
                                  "Pengguna dapat melihat total tagihan akhir yang diperoleh, serta memilih metode pembayaran yang tersedia. Setelah pembayaran selesai, sistem akan menampilkan notifikasi Pembayaran Berhasil. Pengguna kemudian dapat membuka menu Riwayat untuk melihat riwayat kunjungan Dental Care yang baru saja diselesaikan.",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for every numbered step inside the big card
  Widget _guideStep({
    required int number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number bubble / number text
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "$number.",
            style: AppTextStyles.input.copyWith(
              color: AppColors.gold,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Title + description column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.gold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textLight,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
