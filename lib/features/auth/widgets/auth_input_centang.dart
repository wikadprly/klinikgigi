import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class CustomAgreementCheckbox extends StatefulWidget {
  final String label; // Tambahkan properti label agar bisa digunakan di DaftarPasienBaruScreen
  final ValueChanged<bool>? onChanged;
  final bool initialValue;

  const CustomAgreementCheckbox({
    super.key,
    required this.label,
    this.onChanged,
    this.initialValue = false,
  });

  @override
  State<CustomAgreementCheckbox> createState() =>
      _CustomAgreementCheckboxState();
}

class _CustomAgreementCheckboxState extends State<CustomAgreementCheckbox> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.initialValue;
  }

  void toggleCheckbox() {
    setState(() {
      checked = !checked;
    });
    widget.onChanged?.call(checked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCheckbox,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kotak centang custom
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: checked ? AppColors.gold : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: checked ? AppColors.gold : AppColors.goldDark,
                width: 2,
              ),
            ),
            child: checked
                ? const Icon(Icons.check, size: 16, color: AppColors.background)
                : null,
          ),
          const SizedBox(width: 8),

          // Label teks
          Expanded(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
