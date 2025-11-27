import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/rectangle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/tampilan_akhir_reservasi.dart';

class ReservasiPembayaranQrisPage extends StatelessWidget {
  final String namaLengkap;
  final String poli;
  final String dokter;
  final String tanggal;
  final String jam;
  final String keluhan;
  final int total;

  const ReservasiPembayaranQrisPage({
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
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Kode Pembayaran",
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 20,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 💰 Status & Total
              Text(
                "Menunggu Pembayaran",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 17,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rp$total",
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 22,
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.access_time,
                    color: AppColors.gold,
                    size: 45,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "Kadaluarsa dalam",
                style: AppTextStyles.label.copyWith(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Jatuh Tempo pada 17:06, 4 Nov 2025",
                style: AppTextStyles.label.copyWith(
                  fontSize: 14,
                  color: AppColors.goldDark,
                ),
              ),

              const SizedBox(height: 26),

              // 🟦 QRIS Box
              Rectangle(
                width: double.infinity,
                height: 420,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(Icons.qr_code, color: AppColors.gold, size: 26),
                          const SizedBox(width: 10),
                          Text(
                            "QRIS",
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 18,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // QR Placeholder
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.goldDark, width: 1),
                            ),
                            child: const Icon(
                              Icons.qr_code_2,
                              size: 170,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Save QR Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.download, color: Colors.black, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Simpan Kode",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),
              // ✅ Button Selesai
              AuthButton(
              text: "Selesai",
              onPressed: () async {
                final reservasiData = {
                  'nama': namaLengkap,
                  'poli': poli,
                  'dokter': dokter,
                  'tanggal': tanggal,
                  'jam': jam,
                  'keluhan': keluhan,
                  'biaya': total.toString(),
                };

                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TampilanAkhirReservasi(data: reservasiData),
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
