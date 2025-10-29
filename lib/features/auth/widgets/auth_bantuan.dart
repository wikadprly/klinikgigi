import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class AuthBantuan extends StatelessWidget {
  final VoidCallback onTap;

  const AuthBantuan({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(Icons.headset),
        color: AppColors.goldDark,
        iconSize: 40,
        tooltip: 'Bantuan',
      ),
    );
  }
}
