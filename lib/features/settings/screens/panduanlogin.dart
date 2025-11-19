import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class PanduanLoginPage extends StatelessWidget {
  const PanduanLoginPage({super.key});

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
                  BackButtonWidget(
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Panduan Aplikasi",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.goldDark,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TOP TITLE
                      Text(
                        "Panduan Login",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 22,
                          color: AppColors.goldDark,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Proses masuk sangat cepat! Hanya butuh beberapa detik. Anda tidak perlu membuang waktu untuk mulai menggunakan layanan kami.",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textLight,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// BOX 1 — Panduan Login
                      _GuideBox(
                        title: "Panduan Login",
                        steps: const [
                          "Buka aplikasi dan masuk ke halaman Login.",
                          "Masukkan Email/Username dan Kata Sandi.",
                          "Tekan tombol Masuk.",
                          "Sistem akan memeriksa:",
                          "Jika terjadi masalah lain (akun tidak ada, internet error, dll.) → muncul pesan Login gagal.",
                        ],
                        bulletDetail: const [
                          [
                            "Akun ditemukan → lanjut ke pengecekan kata sandi.",
                            "Kata sandi benar → kamu langsung masuk ke aplikasi.",
                            "Kata sandi salah → muncul pesan 'Kata sandi tidak sesuai'.",
                          ]
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// BOX 2 — Panduan Daftar Pasien Baru
                      _GuideBox(
                        title: "Panduan Daftar (Pasien Baru)",
                        steps: const [
                          "Buka halaman Daftar Akun.",
                          "Isi semua data pribadi:",
                          "Tekan tombol Daftar.",
                          "Sistem membuat akun baru dan kamu langsung mendapatkan:",
                          "Jika gagal daftar:",
                        ],
                        bulletDetail: const [
                          [
                            "Nama lengkap, NIK, Tanggal lahir, Jenis kelamin, Nomor HP, Email, Kata sandi & Konfirmasi kata sandi.",
                          ],
                          [
                            "User ID, Nama Pengguna, Email, dan langsung masuk otomatis ke aplikasi.",
                          ],
                          [
                            "NIK, email, atau nomor HP sudah digunakan.",
                            "Format email tidak valid.",
                            "Kata sandi kurang dari 8 karakter.",
                          ]
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// BOX 3 — Panduan Daftar Pasien Lama
                      _GuideBox(
                        title: "Panduan Daftar (Pasien Lama)",
                        steps: const [
                          "Buka aplikasi, lalu pilih menu Daftar.",
                          "Pilih opsi Pasien Lama.",
                          "Masukkan Nomor Rekam Medis (RM) dan tekan Lanjutkan.",
                          "Jika RM ditemukan, data dasar otomatis muncul:",
                          "Isi bagian yang perlu kamu lengkapi:",
                          "Tekan Buat Akun.",
                          "Jika berhasil, kamu langsung masuk ke aplikasi secara otomatis.",
                          "Jika gagal:",
                        ],
                        bulletDetail: const [
                          [
                            "Nama, NIK, tanggal lahir, jenis kelamin, nomor HP."
                          ],
                          [
                            "Email (opsional)",
                            "Password Baru",
                            "Konfirmasi Password",
                          ],
                          [
                            "RM tidak ditemukan → muncul pesan kesalahan.",
                            "RM sudah pernah dibuatkan akun → kamu diminta langsung login."
                          ]
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// BOX 4 — OTP SECTION TITLE
                      Text(
                        "Mengirim & Verifikasi Kode OTP",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 20,
                          color: AppColors.goldDark,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// BOX 5 — Request OTP
                      _GuideBox(
                        title: "Cara Mengirim Kode OTP ke Email (Request OTP)",
                        steps: const [
                          "Masukkan email kamu pada halaman OTP.",
                          "Tekan Kirim OTP.",
                          "Cek email, kamu akan menerima kode OTP 6 digit (berlaku 5 menit).",
                          "Jika belum muncul, tunggu sebentar. Kamu baru bisa minta ulang setelah 1 menit.",
                          "Jika gagal kirim OTP:",
                        ],
                        bulletDetail: const [
                          [
                            "Terlalu banyak permintaan (maks 3 per jam) → coba lagi nanti.",
                            "Minta ulang terlalu cepat → tunggu 1 menit.",
                            "Format email salah → periksa kembali email kamu.",
                          ]
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// BOX 6 — Verifikasi OTP
                      _GuideBox(
                        title: "Cara Verifikasi Kode OTP",
                        steps: const [
                          "Masukkan email dan kode OTP 6 digit yang kamu terima.",
                          "Tekan Verifikasi.",
                          "Jika benar dan masih berlaku → kamu langsung berhasil masuk.",
                          "Jika gagal verifikasi:",
                        ],
                        bulletDetail: const [
                          [
                            "OTP sudah kadaluarsa (lebih dari 5 menit).",
                            "Kode salah atau terlalu banyak salah (maks 5) → email diblokir sementara 15 menit."
                          ]
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ======================================================
/// KOMPONEN BOX PANDUAN
/// ======================================================
class _GuideBox extends StatelessWidget {
  final String title;
  final List<String> steps;
  final List<List<String>> bulletDetail;

  const _GuideBox({
    required this.title,
    required this.steps,
    required this.bulletDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: AppTextStyles.heading.copyWith(
              fontSize: 18,
              color: AppColors.goldDark,
            ),
          ),

          const SizedBox(height: 10),

          /// Steps + bullets
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (index) {
              final hasBullets = index < bulletDetail.length;
              final bullets = hasBullets ? bulletDetail[index] : null;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Step number
                    Text(
                      "${index + 1}. ${steps[index]}",
                      style: AppTextStyles.label.copyWith(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),

                    /// Bullet details under the step
                    if (bullets != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 18, top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: bullets!
                              .map(
                                (b) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "• ",
                                        style: TextStyle(
                                          color: AppColors.textLight,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          b,
                                          style: AppTextStyles.label.copyWith(
                                            color: AppColors.textLight,
                                            fontSize: 14,
                                            height: 1.4,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
