import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart'; // pastikan path ini benar

class CustomAgreementCheckbox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  const CustomAgreementCheckbox({super.key, this.onChanged});

  @override
  State<CustomAgreementCheckbox> createState() =>
      _CustomAgreementCheckboxState();
}

class _CustomAgreementCheckboxState extends State<CustomAgreementCheckbox> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => checked = !checked);
        widget.onChanged?.call(checked);
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: checked ? AppColors.gold : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.goldDark, width: 2),
            ),
            child: checked
                ? const Icon(Icons.check, size: 16, color: AppColors.background)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            "Setuju dan lanjutkan",
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
