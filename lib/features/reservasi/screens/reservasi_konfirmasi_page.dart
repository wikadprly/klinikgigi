import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Farel Sheva Basudewa",
                          style: AppTextStyles.input.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "No. Rekam Medis: 11100000",
                          style: AppTextStyles.label.copyWith(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ================================
              // Tombol Pilih Jadwal Periksa
              // ================================
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Pilih Jadwal Periksa",
                    style: AppTextStyles.button.copyWith(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ================================
              // Kotak utama Konfirmasi Data
              // ================================
              PersegiPanjang(
                width: width,
                height: 560,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul bagian atas dengan garis bawah
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.amber, width: 1.2),
                        ),
                      ),
                      child: Text(
                        "Konfirmasi Data Pendaftaran",
                        style: AppTextStyles.heading.copyWith(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ================================
                    // Kelompok 1: Data Pasien
                    // ================================
                    _buildDataText("Nama Lengkap", ""),
                    _buildDataText("Tempat, Tanggal Lahir", ""),
                    _buildDataText("Alamat", ""),
                    _buildDataText("No. HP", ""),
                    _buildDataText("Jenis Pasien", ""),
                    const SizedBox(height: 8),
                    Container(height: 1, color: Colors.amber.withOpacity(0.8)),
                    const SizedBox(height: 8),

                    // ================================
                    // Kelompok 2: Data Layanan
                    // ================================
                    _buildDataText("Poli", ""),
                    _buildDataText("Dokter", ""),
                    _buildDataText("Tanggal", ""),
                    _buildDataText("Waktu Layanan", ""),
                    const SizedBox(height: 8),

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Pembayaran",
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Rp 25.000",
                          style: AppTextStyles.input.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C6C6C),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Batal",
                              style: TextStyle(
                                color: Colors.white,
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
                              backgroundColor: const Color(0xFF6C6C6C),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Bayar",
                              style: TextStyle(
                                color: Colors.white,
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
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: AppTextStyles.input.copyWith(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
