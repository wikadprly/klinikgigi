import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Definisikan warna yang lebih konsisten
const Color activeColor = Color(0xFFFFC107); // Kuning/Amber terang
const Color inactiveColor = Color.fromARGB(255, 60, 60, 60); // Abu-abu gelap untuk garis non-aktif
const Color textColor = Colors.white; // TETAP PUTIH untuk teks biasa
const Color cardBackground = Color(0xFF2C2C2C); // Warna latar belakang untuk Card Info

class TimelineProgresModule extends StatelessWidget {
  const TimelineProgresModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding di luar
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. KOTAK HEADER INFORMASI (Card) dengan garis tepi
          Container(
            padding: const EdgeInsets.all(20.0),
            width: double.infinity,
            decoration: BoxDecoration(
              // Background Card 
              color: cardBackground, 
              borderRadius: BorderRadius.circular(15),
              // Garis tepi (border) tipis berwarna abu-abu/putih samar
              border: Border.all(color: Colors.white12, width: 1), 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ID Kunjungan: HDC-829292",
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  "Drg. Agus Suktamo",
                  style: TextStyle(
                    // Warna font Dokter menjadi KUNING
                    color: activeColor, 
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Jadwal: 3 November 2025, 17.00 WIB",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Text(
                  "Perkiraan waktu tiba: 15 menit",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 35),
          
          // 2. Timeline Items
          _TimelineTileItem(
            isFirst: true,
            icon: Icons.assignment_ind,
            title: "Dokter Telah Ditugaskan",
            subtitle: "Drg. Agus Suktamo akan menangani Anda.",
            isActive: true, 
          ),

          _TimelineTileItem(
            isFirst: false,
            icon: Icons.location_on,
            title: "Dokter Dalam Perjalanan",
            subtitle: "Dokter sedang menuju lokasi Anda.",
            isActive: true, 
          ),

          _TimelineTileItem(
            isFirst: false,
            icon: Icons.local_hospital,
            title: "Pemeriksaan Berlangsung",
            subtitle: "Pemeriksaan belum dimulai.",
            isActive: false, 
          ),

          _TimelineTileItem(
            isFirst: false,
            isLast: true,
            icon: Icons.receipt_long,
            title: "Menunggu Rincian Biaya",
            subtitle: "Tagihan akan tersedia setelah tindakan selesai.",
            isActive: false, 
          ),
        ],
      ),
    );
  }
}

class _TimelineTileItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isActive;

  const _TimelineTileItem({
    super.key, // Menambahkan key agar best practice
    this.isFirst = false,
    this.isLast = false,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      alignment: TimelineAlign.start,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: Container(
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.white70,
              size: 20,
            ),
          ),
        ),
      ),
      beforeLineStyle: LineStyle(
        color: isActive ? activeColor : inactiveColor,
        thickness: 2,
      ),
      afterLineStyle: LineStyle( 
        color: isActive ? activeColor : inactiveColor,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                // Warna judul status aktif (Kuning)
                color: isActive ? activeColor : textColor, 
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}