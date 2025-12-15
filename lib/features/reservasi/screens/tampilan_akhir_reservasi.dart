import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
// Pastikan path ini sesuai dengan struktur folder kamu
import 'package:flutter_klinik_gigi/features/home/screens/main_screen.dart'; 

class TampilanAkhirReservasi extends StatelessWidget {
  final Map<String, dynamic> data;

  const TampilanAkhirReservasi({
    super.key,
    required this.data,
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
    // Ambil data (aman dari null)
    final noPemeriksaan = data['noPemeriksaan'] ?? '-';

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
                    border: Border.all(
                      color: AppColors.gold,
                      width: 3,
                    ),
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
                  "Pendaftaran Berhasil",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 22,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Data Anda telah tersimpan.\nLakukan pembayaran agar mendapatkan Nomor Antrian.",
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
                        "KODE BOOKING / PEMBAYARAN",
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

                      // --- NOMOR ANTRIAN (LOGIKA DOSEN) ---
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Menunggu Lunas", // Placeholder
                              style: TextStyle(
                                color: Colors.amberAccent,
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
                      detailRow(label: "Nama Pasien :", value: data["nama"] ?? "-"),
                      detailRow(label: "Dokter :", value: data["dokter"] ?? "-"),
                      detailRow(label: "Poli :", value: data["poli"] ?? "-"),
                      detailRow(label: "Jadwal :", value: "${data["tanggal"]} (${data["jam"]})"),
                      const Divider(color: Colors.white12, height: 20),
                      detailRow(label: "Total Biaya :", value: "Rp ${data["biaya"] ?? "0"}", isBold: true),
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