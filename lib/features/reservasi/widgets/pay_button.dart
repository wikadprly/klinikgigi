import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class PayButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;
  final String label;

  const PayButton({
<<<<<<< HEAD
    Key? key,
    required this.onPressed,
    this.isEnabled = true,
    this.label = 'Bayar',
  }) : super(key: key);
=======
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.label = 'Bayar',
  });
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppColors.gold
<<<<<<< HEAD
              : AppColors.gold.withOpacity(0.45),
=======
              : AppColors.gold.withValues(alpha: 0.45),
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
