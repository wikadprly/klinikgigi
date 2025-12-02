// lib/features/dental_home/screens/dental_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class DentalHomeScreen extends StatefulWidget {
  const DentalHomeScreen({super.key});

  @override
  State<DentalHomeScreen> createState() => _DentalHomeScreenState();
}

class _DentalHomeScreenState extends State<DentalHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dental Home Care', style: AppTextStyles.heading),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.local_hospital,
                    color: AppColors.gold,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Layanan Dental Home Care',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Dapatkan layanan kesehatan gigi langsung di rumah Anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keuntungan Layanan',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem('• Dokter profesional datang ke rumah Anda'),
                  const SizedBox(height: 8),
                  _buildBenefitItem('• Waktu fleksibel sesuai kebutuhan'),
                  const SizedBox(height: 8),
                  _buildBenefitItem('• Pelayanan medis berkualitas tinggi'),
                  const SizedBox(height: 8),
                  _buildBenefitItem('• Proses booking mudah dan cepat'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to schedule page
                  Navigator.pushNamed(context, '/dentalhome/jadwal');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pesan Sekarang',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.substring(0, 1),
          style: const TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text.substring(1),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
