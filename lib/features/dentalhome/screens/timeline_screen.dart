import 'package:flutter/material.dart';
import 'timeline_progres.dart'; 

class TimelineScreen extends StatelessWidget {
  // Deklarasi callback (aksi yang akan dilakukan saat tombol ditekan)
  final VoidCallback onBack;
  final VoidCallback onPayment;
  final VoidCallback onHome;

  const TimelineScreen({
    super.key,
    required this.onBack,
    required this.onPayment,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    // Definisi warna konsisten
    const Color darkBackground = Color(0xFF1E1E1E); // Latar Belakang Gelap
    const Color primaryColor = Color(0xFFFFC107); // Kuning/Amber Emas
    const Color whiteColor = Colors.white; // Tambahkan warna putih

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lacak Kunjungan Anda',
          style: TextStyle(
            // Warna font App Bar tetap KUNING Emas
            color: primaryColor, 
            fontWeight: FontWeight.w500, 
          ), 
        ),
        backgroundColor: darkBackground, 
        elevation: 0, 
        // Mengubah foregroundColor kembali ke putih atau transparent
        foregroundColor: whiteColor, 
        leading: IconButton(
          // PERBAIKAN UTAMA DI SINI: Tombol Kembali (<) diubah menjadi PUTIH
          icon: const Icon(Icons.arrow_back, color: whiteColor), 
          onPressed: onBack, 
        ),
      ),
      backgroundColor: darkBackground, 
      body: Stack(
        children: [
          // Konten Utama yang Dapat di-Scroll (Modul Timeline)
          const SingleChildScrollView(
            // Memberi padding di bawah agar konten tidak tertutup tombol fixed
            padding: EdgeInsets.only(bottom: 140), 
            child: TimelineProgresModule(), 
          ),

          // Tombol Aksi di Bagian Bawah Layar (Fixed Position)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // Background container harus sama dengan Scaffold agar mulus
              color: darkBackground, 
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TOMBOL SELESAIKAN PEMBAYARAN (Solid Kuning)
                  ElevatedButton(
                    onPressed: onPayment, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, 
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0, 
                    ),
                    child: const Text(
                      'Selesaikan Pembayaran',
                      style: TextStyle(
                        color: Colors.black, // Teks Hitam agar kontras dengan latar kuning
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // TOMBOL KEMBALI KE BERANDA (Outlined, Border Kuning)
                  OutlinedButton(
                    onPressed: onHome, 
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: primaryColor, width: 2), // Garis tepi Emas
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        color: primaryColor, // Warna font Emas
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
