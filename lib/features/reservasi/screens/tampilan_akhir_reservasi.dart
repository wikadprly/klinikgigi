import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';

class TampilanAkhirReservasi extends StatelessWidget {
  const TampilanAkhirReservasi({super.key});

  Widget detailRow({required String label, String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (E.g., No. Pemeriksaan :)
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
            value ?? "",
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
                const SizedBox(height: 14),

                const SizedBox(height: 30),

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.gold, AppColors.gold.withOpacity(0.6)],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Pendaftaran Berhasil",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 25,
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

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(color: AppColors.goldDark, width: 1.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris 1: No. Pemeriksaan
                      detailRow(label: "No. Pemeriksaan :"),
                      const Divider(
                        color: AppColors.goldDark,
                        height: 24,
                        thickness: 1,
                      ),

                      // Baris 2 sampai 8
                      detailRow(label: "Nama :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Waktu Layanan :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Hari/Tanggal :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Dokter :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Poli :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Keluhan :"),
                      const SizedBox(height: 12),

                      detailRow(label: "Biaya Administrasi :"),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Button
                AuthButton(
                  text: ButtonText.lihatRiwayat,
                  onPressed: () async {
                    // TODO: Tambahkan navigasi ke halaman riwayat di sini
                    debugPrint("Navigate to history page");
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
