import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class PanduanReservasiPage extends StatelessWidget {
  const PanduanReservasiPage({super.key});

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
                      Text(
                        "Panduan Reservasi",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.gold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Jangan khawatir, reservasi Anda ada di tangan yang tepat! "
                        "Proses kami dirancang agar mudah, cepat, dan 100% terkonfirmasi.",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textLight,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.gold, width: 1),
                          color: AppColors.cardDark,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _step(
                              number: 1,
                              title: "Login / Cek User",
                              description:
                                  "Masuk ke aplikasi dengan akun yang sudah dibuat.",
                            ),
                            const SizedBox(height: 12),

                            _step(
                              number: 2,
                              title: "Pilih Poli",
                              description:
                                  "Pilih jenis poli sesuai kebutuhan, misal: Poli gigi umum. "
                                  "Bisa juga menggunakan opsi “Semua Poli” jika ingin melihat jadwal semua dokter.",
                            ),
                            const SizedBox(height: 12),

                            _step(
                              number: 3,
                              title: "Pilih Dokter",
                              description:
                                  "Sistem akan menampilkan daftar dokter sesuai poli yang kamu pilih. "
                                  "Jika kamu memilih 'Semua Poli', daftar dokter tidak difilter. "
                                  "Kamu bisa memilih dokter tertentu atau semua dokter yang tersedia "
                                  "untuk mengecek jadwal lebih lengkapnya.",
                            ),
                            const SizedBox(height: 12),

                            _step(
                              number: 4,
                              title: "Pilih Tanggal",
                              description:
                                  "Pilih tanggal yang ingin kamu kunjungi di klinik atau tanggal yang kamu inginkan.",
                            ),
                            const SizedBox(height: 12),

                            _step(
                              number: 5,
                              title: "Pilih Jadwal",
                              description:
                                  "Setelah pilih jadwal lalu klik cek jadwal maka akan muncul jadwal dokter yang bisa kamu pilih. "
                                  "Sistem akan menampilkan jam praktik dan kuota yang tersisa serta nama dokter.",
                            ),
                            const SizedBox(height: 12),

                            _step(
                              number: 6,
                              title: "Konfirmasi Reservasi",
                              description:
                                  "Tinjau semua data reservasi: dokter, poli, tanggal, jam, dan nama pasien. "
                                  "Jika sudah sesuai, klik 'Bayar' untuk melanjutkan.",
                            ),
                            const SizedBox(height: 12),

                            _step(
                              number: 7,
                              title: "Klik 'Buat Reservasi'",
                              description:
                                  "Sistem akan otomatis menyimpan data kamu dalam antrian dan memberikan nomor "
                                  "antrian ketika pembayaran sudah selesai dan disebutkan admin.",
                            ),
                            const SizedBox(height: 12),

                            _step(
                              number: 8,
                              title: "Selesai / Riwayat",
                              description:
                                  "Setelah pembayaran berhasil dan disetujui admin, data reservasi akan masuk ke menu riwayat. "
                                  "Dari sana kamu bisa mengecek riwayat reservasi kamu—datang ke klinik sesuai jadwal, "
                                  "hadiri klinik sesuai jadwal yang sudah dipilih. "
                                  "Tunjukkan kode pemesanan untuk proses pemeriksaan di klinik.",
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

  Widget _step({
    required int number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$number.",
          style: AppTextStyles.input.copyWith(
            color: AppColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
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
