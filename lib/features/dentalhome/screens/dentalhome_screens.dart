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
        title: const Text('Dental Home', style: AppTextStyles.heading),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: const Center(
        child: Text('Ini Halaman Dental Home', style: AppTextStyles.input),
      ),
    );
  }
}
