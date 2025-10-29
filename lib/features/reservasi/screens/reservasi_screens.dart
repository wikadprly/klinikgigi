// lib/features/pendaftaran/screens/pendaftaran_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class PendaftaranScreen extends StatefulWidget {
  const PendaftaranScreen({super.key});

  @override
  State<PendaftaranScreen> createState() => _PendaftaranScreenState();
}

class _PendaftaranScreenState extends State<PendaftaranScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pendaftaran', style: AppTextStyles.heading),
        backgroundColor: AppColors.background, // Atau warna app bar kustom
        elevation: 0, // Hilangkan bayangan jika perlu
        iconTheme: const IconThemeData(
          color: AppColors.textLight,
        ), // Warna ikon back jika ada
      ),
      body: const Center(
        child: Text('Ini Halaman Pendaftaran', style: AppTextStyles.input),
      ),
    );
  }
}
