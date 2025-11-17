import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang_garis.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';

class ReservasiPembayaranBank2Page extends StatelessWidget {
  const ReservasiPembayaranBank2Page({super.key});

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
              // 🔙 Header
              Row(
                children: [
                  BackButtonCircle(onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 16),
                  Text(
                    "Kode Pembayaran",
                    style: AppTextStyles.heading.copyWith(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 💳 Rincian Pembayaran
              Text(
                "Rincian Pembayaran",
                style: AppTextStyles.label.copyWith(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),

              // 💰 Box Total Pembayaran
              PersegiPanjang(
                width: double.infinity,
                height: 95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Baris total pembayaran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Pembayaran",
                          style: AppTextStyles.label.copyWith(
                            fontSize: 15,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          "Rp25.000",
                          style: AppTextStyles.input.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),

                    // ✨ Garis emas penuh pemisah
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1.5,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Baris waktu bayar dalam
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bayar Dalam",
                          style: AppTextStyles.label.copyWith(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          "23 jam 58 menit 31 detik",
                          style: AppTextStyles.input.copyWith(
                            fontSize: 14,
                            color: AppColors.goldDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🏦 Bank BCA Section
              PersegiPanjang(
                width: double.infinity,
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian atas: teks "Bank BCA"
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 30,
                          color: Colors.transparent,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Bank BCA",
                          style: AppTextStyles.input.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    // ✨ Garis pemisah emas di dalam kotak
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 1.2,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Bagian bawah: nomor virtual account (digeser & warna gold)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ), // 🔹 geser dikit ke kanan
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No. Rek/Virtual Account",
                            style: AppTextStyles.label.copyWith(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "123 4567 8910 1112",
                            style: AppTextStyles.input.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldDark, // 🟡 ubah jadi gold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 📱 Petunjuk Transfer
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔸 mBanking
                      Text(
                        "Petunjuk Transfer mBanking",
                        style: AppTextStyles.input.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Pilih m-Transfer > BCA Virtual Account.\n\n"
                        "Masukkan nomor Virtual Account 123 4567 8910 1112 dan pilih Send.\n\n"
                        "Masukkan PIN m-BCA Anda dan pilih OK.",
                        style: AppTextStyles.input.copyWith(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 🔸 ATM
                      Text(
                        "Petunjuk Transfer ATM",
                        style: AppTextStyles.input.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Pilih Transaksi Lainnya > Transfer > Ke Rek BCA Virtual Account.\n\n"
                        "Masukkan nomor Virtual Account 123 4567 8910 1112 dan pilih Benar.",
                        style: AppTextStyles.input.copyWith(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Tombol Selesai
              AuthButton(
                text: ButtonText.selesai,
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
