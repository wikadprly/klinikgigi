import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/rectangle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';

class ReservasiPembayaranQris2Page extends StatelessWidget {
  const ReservasiPembayaranQris2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button dan Title
              Row(
                children: [
                  BackButtonCircle(
                    borderColor: AppColors.gold,
                    iconColor: AppColors.gold,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Kode Pembayaran",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),

              // Status Pembayaran + Nominal + Jam
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Menunggu Pembayaran",
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 18,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "RP.25.000,00",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 22,
                          color: AppColors.gold,
                        ),
                      ),
                      const Icon(
                        Icons.access_time,
                        color: AppColors.gold,
                        size: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Kadaluarsa dalam",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.gold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Jatuh Tempo pada 17:06, 4 Nov 2025",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.gold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Widget Persegi Panjang QRIS (diperbesar height)
              Rectangle(
                width: double.infinity,
                height: 420, // diperbesar
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header QRIS
                      Row(
                        children: [
                          const Icon(
                            Icons.qr_code,
                            color: AppColors.gold,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "QRIS",
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 18,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Placeholder QR
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            color: AppColors.inputBorder.withAlpha(
                              (0.3 * 255).toInt(),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tombol Simpan Kode dengan ikon download, mengikuti ukuran AuthButton
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            return;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.download,
                                size: 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Simpan Kode",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Kembali ke Beranda
              AuthButton(
                text: ButtonText.kembaliKeBeranda,
                onPressed: () async {
                  return;
                },
              ),

              const Spacer(),

              // Selesai
              AuthButton(
                text: ButtonText.selesai,
                onPressed: () async {
                  return;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
