import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE1D07E);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10), // Latar belakang gelap
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1C),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            color: goldColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: goldColor),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NotificationCard(
              title: "Notifikasi Janji Temu",
              items: [
                "Pengingat jadwal pemeriksaan",
                "Konfirmasi janji temu",
              ],
            ),
            SizedBox(height: 16),
            NotificationCard(
              title: "Notifikasi Rekam Medis",
              items: [
                "Hasil pemeriksaan",
                "Catatan dokter",
              ],
            ),
            SizedBox(height: 16),
            NotificationCard(
              title: "Notifikasi Umum",
              items: [  
                "Promo & diskon",
                "Informasi klinik",
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Card Notifikasi
class NotificationCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const NotificationCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE1D07E);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: goldColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul kategori
          Text(
            title,
            style: const TextStyle(
              color: goldColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: goldColor, thickness: 0.6),

          // Daftar item notifikasi
          for (var item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                item,
                style: const TextStyle(
                  color: goldColor,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
