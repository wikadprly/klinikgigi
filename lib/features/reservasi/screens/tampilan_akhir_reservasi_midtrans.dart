import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/home/screens/main_screen.dart';

class TampilanAkhirReservasiMidtrans extends StatelessWidget {
  final String noPemeriksaan;
  final String nama;
  final String dokter;
  final String poli;
  final String tanggal;
  final String jam;
  final String keluhan;
  final int biaya;
  final String? noAntrian;
  final String? statusPembayaran; // ✅ TAMBAHAN STATUS

  const TampilanAkhirReservasiMidtrans({
    super.key,
    required this.noPemeriksaan,
    required this.nama,
    required this.dokter,
    required this.poli,
    required this.tanggal,
    required this.jam,
    required this.keluhan,
    required this.biaya,
    this.noAntrian,
    this.statusPembayaran, // ✅ TAMBAHAN STATUS
  });

  // --- DETAIL ROW HELPER ---
  Widget detailRow({
    required String label,
    required String value,
    bool isBold = false,
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
                fontSize: 14.5,
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
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? AppColors.gold : Colors.white,
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
                // JARAK ATAS
                const SizedBox(height: 20),

                // TOMBOL KEMBALI
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButtonWidget(
                    onPressed: () async {
                      await _keMenuUtama(context);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ICON CHECK
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 3),
                    color: AppColors.cardDark,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 50,
                      color: AppColors.gold,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // TITLE
                Text(
                  "Pembayaran Berhasil",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 22,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Terima kasih, pembayaran telah berhasil diproses.\nSilakan datang sesuai jadwal yang telah dipilih.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // 2. CARD UTAMA (KODE BOOKING & NO ANTRIAN)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.goldDark, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      // --- KODE PEMBAYARAN ---
                      Text(
                        "KODE PEMERIKSAAN",
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        noPemeriksaan, // Munculkan No RSV disini
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.gold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const Divider(color: Colors.white24, height: 30),

                      // --- STATUS PEMBAYARAN ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status Pembayaran:",
                            style: AppTextStyles.label.copyWith(
                              fontSize: 15,
                              color: AppColors.textLight,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusPembayaran ?? "Lunas",
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(color: Colors.white24, height: 30),

                      // --- NOMOR ANTRIAN ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nomor Antrian:",
                            style: AppTextStyles.label.copyWith(
                              fontSize: 15,
                              color: AppColors.textLight,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: noAntrian != null && noAntrian != '-'
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.amberAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              noAntrian != null && noAntrian != '-'
                                  ? noAntrian!
                                  : "Menunggu Proses",
                              style: TextStyle(
                                color: noAntrian != null && noAntrian != '-'
                                    ? Colors.greenAccent
                                    : Colors.amberAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CARD DETAIL LAINNYA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailRow(label: "Nama Pasien :", value: nama),
                      detailRow(label: "Dokter :", value: dokter),
                      detailRow(label: "Poli :", value: poli),
                      detailRow(label: "Jadwal :", value: "$tanggal ($jam)"),
                      const Divider(color: Colors.white12, height: 20),
                      detailRow(
                        label: "Total Biaya :",
                        value: "Rp $biaya",
                        isBold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 3. BUTTON SELESAI (KE MENU UTAMA)
                AuthButton(
                  text: "Selesai", // ✅ Diganti string biar aman
                  onPressed: () async {
                    await _keMenuUtama(context);
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

  Future<void> _keMenuUtama(BuildContext context) async {
    // Pastikan rute '/main' atau MainScreen sudah ada
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(), // Panggil MainScreen standar
      ),
      (route) => false, // Hapus semua riwayat halaman sebelumnya
    );
  }
}
