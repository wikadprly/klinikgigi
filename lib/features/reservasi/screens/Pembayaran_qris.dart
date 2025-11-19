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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BackButtonWidget(
                            onPressed: () {
                              Navigator.pop(context);
                            },
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

                      // 💰 STATUS + TOTAL
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
                            children: [
                              Text(
                                "RP.${total.toString()},00",
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

                      // 🟦 BOX QRIS
                      Rectangle(
                        width: double.infinity,
                        height: 420, // Ini biang kerok utamanya, tapi gpp
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

                              // QR placeholder
                              Expanded(
                                child: Center(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    color: AppColors.inputBorder.withOpacity(
                                      0.3,
                                    ),
                                    child: const Icon(
                                      Icons.qr_code_2,
                                      size: 180,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 🔽 Simpan Kode QR
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // logic save nanti disini
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.gold,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
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

                      // 🏠 Kembali ke Beranda (INI NGGAK LIXA UBAH)
                      AuthButton(
                        text: "Kembali ke Beranda",
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReservasiScreen(),
                            ),
                          );
                        },
                      ),

                      // const Spacer(), <-- SPACER-NYA KITA HAPUS
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              AuthButton(
                text: "Selesai",
                onPressed: () async {
                  final Map<String, dynamic> reservasiData = {
                    'nama': namaLengkap,
                    'poli': poli,
                    'dokter': dokter,
                    'tanggal': tanggal,
                    'jam': jam,
                    'keluhan': keluhan,
                    'biaya': total.toString(), // Kirim total sebagai string
                  };

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TampilanAkhirReservasi(
                        data: reservasiData,
                      ),
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