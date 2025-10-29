import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gold, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.gold,
          size: 20,
        ),
      ),
    );
  }
}
