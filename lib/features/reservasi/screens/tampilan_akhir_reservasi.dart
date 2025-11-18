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

  // -------- WIDGET DETAIL ROW --------
  Widget detailRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textLight,
            fontSize: 15.5,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.input.copyWith(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: AppColors.gold,
            ),
          ),
        ),
      ],
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
                // 👆 BATAS TAMBAHAN

                const SizedBox(height: 20),

                // ===================== ICON CHECK =======================
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold,
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 50,
                      color: AppColors.gold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ===================== TITLE =======================
                Text(
                  "Pendaftaran Berhasil",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Pendaftaran Anda telah berhasil disimpan.\nSilakan datang sesuai jadwal yang tertera di bawah ini.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    fontSize: 14.5,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),

                // ===================== CARD DETAIL =======================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.goldDark, width: 1.5),
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
                        height: 24,
                        thickness: 1,
                      ),

                      detailRow(
                        label: "Nama :",
                        value: data["nama"] ?? "-",
                      ),
                      const SizedBox(height: 12),

                      detailRow(
                        label: "Waktu Layanan :",
                        value: data["jam"] ?? "-",
                      ),
                      const SizedBox(height: 12),

                      detailRow(
                        label: "Hari/Tanggal :",
                        value: data["tanggal"] ?? "-",
                      ),
                      const SizedBox(height: 12),

                      detailRow(
                        label: "Dokter :",
                        value: data["dokter"] ?? "-",
                      ),
                      const SizedBox(height: 12),

                      detailRow(
                        label: "Poli :",
                        value: data["poli"] ?? "-",
                      ),
                      const SizedBox(height: 12),

                      detailRow(
                        label: "Keluhan :",
                        value: data["keluhan"] ?? "-",
                      ),
                      const SizedBox(height: 12),

                      detailRow(
                        label: "Biaya Administrasi :",
                        value: "Rp. ${data["biaya"] ?? "0"}",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ===================== BUTTON KE RIWAYAT DETAIL =======================
                AuthButton(
                  text: ButtonText.lihatRiwayat,
                  onPressed: () async {
                    Navigator.pushNamed(
                      context,
                      "/riwayat_detail",
                      arguments: data, // <-- kirim data lengkap ke detail
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