import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class TipsBox extends StatelessWidget {
  const TipsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.goldDark),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tips bikin Kata Sandi yang aman",
            style: TextStyle(
              color: AppColors.goldDark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "1. Hindari huruf/nomor berulang & berurutan (mis. 12345/abcde)",
            style: AppTextStyles.label,
          ),
          Text(
            "2. Jangan gunakan nama, tanggal lahir, atau nomor HP.",
            style: AppTextStyles.label,
          ),
          Text(
            "3. Buat kata sandi unik & belum pernah digunakan.",
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }
}
