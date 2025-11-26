import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/rectangle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/tampilan_akhir_reservasi.dart';

class ReservasiPembayaranBank2Page extends StatelessWidget {
  final String namaLengkap;
  final String poli;
  final String dokter;
  final String tanggal;
  final String jam;
  final String keluhan;
  final int total;

  const ReservasiPembayaranBank2Page({
    super.key,
    required this.namaLengkap,
    required this.poli,
    required this.dokter,
    required this.tanggal,
    required this.jam,
    required this.keluhan,
    required this.total,
  });

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
                  BackButtonWidget(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReservasiScreen(),
                        ),
                      );
                    },
                  ),
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


              Rectangle(
                width: double.infinity,
                height: 95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Total pembayaran
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
                          "Rp$total",
                          style: AppTextStyles.input.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),

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


              Rectangle(
                width: double.infinity,
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    Padding(
                      padding: const EdgeInsets.only(left: 8),
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
                              color: AppColors.goldDark,
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
                      // mBanking
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

              AuthButton(
                text: 'Selesai',
                onPressed: () async {
                  final Map<String, dynamic> reservasiData = {
                    'nama': namaLengkap,
                    'poli': poli,
                    'dokter': dokter,
                    'tanggal': tanggal,
                    'jam': jam,
                    'keluhan': keluhan,
                    'biaya': total.toString(),
                  };

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TampilanAkhirReservasi(data: reservasiData),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
