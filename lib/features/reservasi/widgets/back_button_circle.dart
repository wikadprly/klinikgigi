import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

<<<<<<< HEAD
  const BackButtonCircle({
    super.key,
    this.onTap,
    this.size = 45,
    this.iconSize = 24,
    this.borderColor = const Color(0xFFFFD580),
    this.iconColor = const Color(0xFFFFD580),
    this.backgroundColor = Colors.transparent,
    this.borderWidth = 3,
  });
=======
  const BackButtonWidget({super.key, required this.onPressed});
>>>>>>> 0717c97 (feat: membuat rectangle.dart)

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
<<<<<<< HEAD
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: iconColor,
            size: iconSize,
          ),
=======
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.gold,
          size: 20,
>>>>>>> 0717c97 (feat: membuat rectangle.dart)
        ),
      ),
    );
  }
}
