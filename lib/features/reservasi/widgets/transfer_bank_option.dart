import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class TransferBankOption extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const TransferBankOption({
<<<<<<< HEAD
    Key? key,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
=======
    super.key,
    required this.isSelected,
    required this.onTap,
  });
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.cardDark;
<<<<<<< HEAD
    final borderColor = isSelected
        ? AppColors.goldDark
        : AppColors.goldDark.withOpacity(0.25);
    final innerColor = isSelected
        ? AppColors.goldDark.withOpacity(0.12)
=======

    final borderColor = isSelected
        ? AppColors.goldDark
        : AppColors.goldDark.withValues(alpha: 0.25);

    final innerColor = isSelected
        ? AppColors.goldDark.withValues(alpha: 0.12)
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
<<<<<<< HEAD
            // ikon bank
=======
            //  ikon bank
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
            Container(
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                color: innerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.account_balance,
                  color: AppColors.goldDark,
                  size: 30,
                ),
              ),
            ),

            const SizedBox(width: 12),

<<<<<<< HEAD
            // teks
=======
            // teks “Transfer Bank”
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
            Expanded(
              child: Text(
                "Transfer Bank",
                style: AppTextStyles.input.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // lingkaran indikator
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
<<<<<<< HEAD
                  color: AppColors.textLight.withOpacity(0.9),
=======
                  color: AppColors.textLight.withValues(alpha: 0.9),
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                  width: 1.6,
                ),
                color: isSelected ? Colors.white : Colors.transparent,
              ),
              child: !isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
