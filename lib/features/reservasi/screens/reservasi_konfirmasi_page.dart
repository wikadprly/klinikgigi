import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
<<<<<<< HEAD
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang_garis.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReservasiKonfirmasiPage(),
    ),
  );
}
=======
import 'package:flutter_klinik_gigi/features/reservasi/widgets/rectangle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back.dart';
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca

class ReservasiKonfirmasiPage extends StatelessWidget {
  const ReservasiKonfirmasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              // ================================
              // Baris atas: tombol kembali + info pasien
              // ================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tombol kembali
                  BackButtonCircle(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 12),

                  // Info pasien (nama + no rekam medis)
=======
              // Baris atas: tombol kembali + info pasien
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BackButtonCircle(onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Farel Sheva Basudewa",
                          style: AppTextStyles.input.copyWith(
<<<<<<< HEAD
                            color: Colors.amber,
=======
                            color: AppColors.gold,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "No. Rekam Medis: 11100000",
                          style: AppTextStyles.label.copyWith(
<<<<<<< HEAD
                            color: Colors.grey[400],
=======
                            color: AppColors.textLight,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

<<<<<<< HEAD
              // ================================
              // Tombol Pilih Jadwal Periksa
              // ================================
=======
              // Tombol Pilih Jadwal Periksa
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Pilih Jadwal Periksa",
                    style: AppTextStyles.button.copyWith(
<<<<<<< HEAD
                      color: Colors.amber,
=======
                      color: AppColors.gold,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

<<<<<<< HEAD
              // ================================
              // Kotak utama Konfirmasi Data
              // ================================
              PersegiPanjang(
=======
              // Kotak utama Konfirmasi Data
              Rectangle(
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                width: width,
                height: 560,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    // Judul bagian atas dengan garis bawah
=======
                    // Judul bagian atas
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        border: Border(
<<<<<<< HEAD
                          bottom: BorderSide(color: Colors.amber, width: 1.2),
=======
                          bottom: BorderSide(color: AppColors.gold, width: 1.2),
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                        ),
                      ),
                      child: Text(
                        "Konfirmasi Data Pendaftaran",
                        style: AppTextStyles.heading.copyWith(
<<<<<<< HEAD
                          color: Colors.amber,
=======
                          color: AppColors.gold,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

<<<<<<< HEAD
                    // ================================
                    // Kelompok 1: Data Pasien
                    // ================================
=======
                    // Kelompok 1: Data Pasien
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                    _buildDataText("Nama Lengkap", ""),
                    _buildDataText("Tempat, Tanggal Lahir", ""),
                    _buildDataText("Alamat", ""),
                    _buildDataText("No. HP", ""),
                    _buildDataText("Jenis Pasien", ""),
                    const SizedBox(height: 8),
<<<<<<< HEAD
                    Container(height: 1, color: Colors.amber.withOpacity(0.8)),
                    const SizedBox(height: 8),

                    // ================================
                    // Kelompok 2: Data Layanan
                    // ================================
=======
                    Container(
                      height: 1,
                      color: AppColors.gold.withValues(
                        alpha: 0.8,
                      ), // ✅ ganti from withOpacity()
                    ),
                    const SizedBox(height: 8),

                    // Kelompok 2: Data Layanan
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                    _buildDataText("Poli", ""),
                    _buildDataText("Dokter", ""),
                    _buildDataText("Tanggal", ""),
                    _buildDataText("Waktu Layanan", ""),
                    const SizedBox(height: 8),
<<<<<<< HEAD

                    // Garis pemisah antara layanan dan keluhan (1 garis saja)
                    Container(height: 1, color: Colors.amber.withOpacity(0.8)),
                    const SizedBox(height: 8),

                    // ================================
                    // Kelompok 3: Keluhan
                    // ================================
                    _buildDataText("Keluhan", ""),
                    const SizedBox(height: 8),
                    Container(height: 1, color: Colors.amber.withOpacity(0.8)),

                    const SizedBox(height: 14),

                    // ================================
                    // Kelompok 4: Total & Tombol
                    // ================================
=======
                    Container(
                      height: 1,
                      color: AppColors.gold.withValues(alpha: 0.8), // ✅
                    ),
                    const SizedBox(height: 8),

                    // Kelompok 3: Keluhan
                    _buildDataText("Keluhan", ""),
                    const SizedBox(height: 8),
                    Container(
                      height: 1,
                      color: AppColors.gold.withValues(alpha: 0.8), // ✅
                    ),

                    const SizedBox(height: 14),

                    // Kelompok 4: Total & Tombol
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Pembayaran",
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w600,
<<<<<<< HEAD
                            color: Colors.white,
=======
                            color: AppColors.textLight,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                          ),
                        ),
                        Text(
                          "Rp 25.000",
                          style: AppTextStyles.input.copyWith(
                            fontWeight: FontWeight.bold,
<<<<<<< HEAD
                            color: Colors.amber,
=======
                            color: AppColors.gold,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

<<<<<<< HEAD
=======
                    // Tombol aksi
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                              backgroundColor: const Color(0xFF6C6C6C),
                              foregroundColor: Colors.white,
=======
                              backgroundColor: AppColors.cardDark,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
<<<<<<< HEAD
                            child: const Text(
                              "Batal",
                              style: TextStyle(
                                color: Colors.white,
=======
                            child: Text(
                              "Batal",
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.textLight,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                              backgroundColor: const Color(0xFF6C6C6C),
                              foregroundColor: Colors.white,
=======
                              backgroundColor: AppColors.gold,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
<<<<<<< HEAD
                            child: const Text(
                              "Bayar",
                              style: TextStyle(
                                color: Colors.white,
=======
                            child: Text(
                              "Bayar",
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.background,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk baris label-data
  Widget _buildDataText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
<<<<<<< HEAD
              color: Colors.white,
=======
              color: AppColors.textLight,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
              fontSize: 14,
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: AppTextStyles.input.copyWith(
<<<<<<< HEAD
                color: Colors.white70,
=======
                color: AppColors.textLight,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
