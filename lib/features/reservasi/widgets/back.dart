import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

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
    this.borderColor = const Color(0xFFFFD580),
    this.iconColor = const Color(0xFFFFD580),
    this.backgroundColor = Colors.transparent,
    this.borderWidth = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            Icons.arrow_back_ios_new_rounded,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
