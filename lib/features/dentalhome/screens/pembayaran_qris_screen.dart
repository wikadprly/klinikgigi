import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PembayaranQrisScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PembayaranQrisScreen({super.key, required this.bookingData});

  @override
  State<PembayaranQrisScreen> createState() => _PembayaranQrisScreenState();
}

class _PembayaranQrisScreenState extends State<PembayaranQrisScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.bookingData;
    final String nominal = data['rincianBiaya']['estimasi_total'].toString();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pembayaran QRIS",
          style: AppTextStyles.heading,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Menunggu Pembayaran",
                    style: AppTextStyles.label,
                  ),
                  Text(
                    "Rp ${int.parse(nominal).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})$'), (Match m) => '.${m[1]}').replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '.${m[1]}')}",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Info Kedaluwarsa
            Text(
              "Jatuh Tempo pada 23:59 WIB",
              style: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Card QRIS
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gold,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: "klinik-gigi-${data['masterJadwalId']}-${DateTime.now().millisecondsSinceEpoch}",
                    version: QrVersions.auto,
                    size: 200.0,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppColors.gold,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Scan QRIS untuk Pembayaran",
                    style: AppTextStyles.label.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tombol Simpan Kode QR
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gold),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  // Fungsi untuk menyimpan gambar QR ke galeri
                  // Implementasi menyimpan gambar QR akan dilakukan nanti
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Fitur simpan QR belum diimplementasikan")),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download,
                      color: AppColors.gold,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Simpan Kode QR",
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tombol Selesai dan Kembali ke Beranda
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Arahkan ke halaman transaksi berhasil setelah pembayaran
                          // Untuk sementara kembali ke beranda
                          Navigator.of(context).pushReplacementNamed('/dashboard');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Selesai",
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/dashboard');
                      },
                      child: Text(
                        "Kembali ke Beranda",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}