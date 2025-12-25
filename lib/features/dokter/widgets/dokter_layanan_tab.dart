import 'package:flutter/material.dart';
import 'dokter_info_card.dart';

class DokterLayananTab extends StatelessWidget {
  final String poli;

  const DokterLayananTab({super.key, required this.poli});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          DokterInfoCard(
            icon: Icons.medical_services_outlined,
            title: "Poliklinik",
            content: poli,
          ),
          const SizedBox(height: 16),
          const DokterInfoCard(
            icon: Icons.verified_outlined,
            title: "Standar Layanan",
            content:
                "Menggunakan peralatan modern dan sterilisasi tingkat tinggi untuk keamanan pasien.",
          ),
        ],
      ),
    );
  }
}
