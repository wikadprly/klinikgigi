import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart';

class TampilanAkhirReservasi extends StatelessWidget {
  final Map<String, dynamic> data;

  const TampilanAkhirReservasi({
    super.key,
    required this.data,
  });

  // --- DETAIL ROW ---
  Widget detailRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textLight,
                fontSize: 15.5,
              ),
            ),
          ),

          // Value
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.input.copyWith(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                // BACK BUTTON
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButtonWidget(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReservasiScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // ICON CHECK
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold,
                      width: 3,
                    ),
                    color: AppColors.cardDark,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 55,
                      color: AppColors.gold,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // TITLE
                Text(
                  "Pendaftaran Berhasil",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Pendaftaran Anda telah berhasil disimpan.\nSilakan datang sesuai jadwal yang tertera di bawah ini.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    fontSize: 14.5,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 35),

                // CARD DETAIL
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.goldDark, width: 1.4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailRow(
                        label: "No. Pemeriksaan :",
                        value: data["no_pemeriksaan"] ?? "-",
                      ),
                      const Divider(
                        color: AppColors.goldDark,
                        height: 26,
                        thickness: 1,
                      ),

                      detailRow(
                        label: "Nama :",
                        value: data["nama"] ?? "-",
                      ),

                      detailRow(
                        label: "Waktu Layanan :",
                        value: data["jam"] ?? "-",
                      ),

                      detailRow(
                        label: "Hari/Tanggal :",
                        value: data["tanggal"] ?? "-",
                      ),

                      detailRow(
                        label: "Dokter :",
                        value: data["dokter"] ?? "-",
                      ),

                      detailRow(
                        label: "Poli :",
                        value: data["poli"] ?? "-",
                      ),

                      detailRow(
                        label: "Keluhan :",
                        value: data["keluhan"] ?? "-",
                      ),

                      detailRow(
                        label: "Biaya Administrasi :",
                        value: "Rp ${data["biaya"] ?? "0"}",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // BUTTON LIHAT RIWAYAT
                AuthButton(
                text: ButtonText.lihatRiwayat,
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    "/riwayat_detail",
                    arguments: data,
                  );
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
