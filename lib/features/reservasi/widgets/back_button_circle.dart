import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

<<<<<<< HEAD
class BackButtonCircle extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color borderColor;
  final Color iconColor;
  final Color backgroundColor;
  final double borderWidth;

  const BackButtonCircle({
    Key? key,
    this.onTap,
    this.size = 45,
    this.iconSize = 24,
    this.borderColor = const Color(0xFFFFD580), // kuning lembut
    this.iconColor = const Color(0xFFFFD580),
    this.backgroundColor = Colors.transparent,
    this.borderWidth = 3,
  }) : super(key: key);
=======
class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonWidget({super.key, required this.onPressed});
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
<<<<<<< HEAD
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded, // <== ini yang kamu mau
            color: iconColor,
            size: iconSize,
          ),
=======
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
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
        ),
      ),
    );
  }
}
