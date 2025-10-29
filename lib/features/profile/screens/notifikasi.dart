import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotifikasiPage(),
  ));
}

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  static const Color goldColor = Color(0xFFD4B46E);
  static const Color backgroundDark = Color(0xFF2A2528);
  static const Color cardDark = Color(0xFF332E31);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan tombol back custom
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: goldColor, width: 1.8),
                      ),
                      child: const Center(
                        child: Text(
                          '<',
                          style: TextStyle(
                            color: goldColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Notifikasi',
                        style: TextStyle(
                          color: goldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // untuk keseimbangan posisi
                ],
              ),
              const SizedBox(height: 20),

              // Notifikasi Janji Temu
              const NotifikasiCard(
                title: 'Notifikasi Janji Temu',
                items: [
                  'Pengingat jadwal pemeriksaan',
                  'Konfirmasi janji temu',
                ],
              ),
              const SizedBox(height: 16),

              // Notifikasi Rekam Medis
              const NotifikasiCard(
                title: 'Notifikasi Rekam Medis',
                items: [
                  'Hasil pemeriksaan',
                  'Catatan dokter',
                ],
              ),
              const SizedBox(height: 16),

              // Notifikasi Umum
              const NotifikasiCard(
                title: 'Notifikasi Umum',
                items: [
                  'Promo & diskon',
                  'Informasi klinik',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotifikasiCard extends StatelessWidget {
  final String title;
  final List<String> items;
  static const Color goldColor = Color(0xFFD4B46E);
  static const Color cardDark = Color(0xFF332E31);

  const NotifikasiCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: goldColor, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: cardDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: goldColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        Container(
  margin: const EdgeInsets.only(top: 4, bottom: 6),
  height: 1.1,
  width: double.infinity,
  color: const Color.fromARGB(255, 212, 180, 110),
),


          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                item,
                style: const TextStyle(
                  color: goldColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
