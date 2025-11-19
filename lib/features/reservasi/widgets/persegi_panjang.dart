import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class PersegiPanjang extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const PersegiPanjang({
    Key? key,
    required this.width,
    required this.height,
    this.child,
    this.backgroundColor,
    this.borderRadius = 18,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardDark,
        borderRadius: BorderRadius.circular(borderRadius),

        border: Border.all(color: AppColors.goldDark, width: 2.0),

        // Sedikit bayangan buat efek depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12.0),
        child: child ?? const SizedBox(),
      ),
    );
  }
}
