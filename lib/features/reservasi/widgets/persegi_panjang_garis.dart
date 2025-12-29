import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class PersegiPanjangGaris extends StatelessWidget {
  final double width;
  final double height;
  final bool showInnerLine; // garis horizontal di tengah
  final double innerLineThickness;
  final Color? innerLineColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? leftChild; // ketika ada dua kolom (kiri)
  final Widget? rightChild; // ketika ada dua kolom (kanan)
  final Widget? centerChild; // ketika ingin konten di tengah

  const PersegiPanjangGaris({
    super.key,
    required this.width,
    required this.height,
    this.showInnerLine = true,
    this.innerLineThickness = 1.5,
    this.innerLineColor,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 18,
    this.padding,
    this.leftChild,
    this.rightChild,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    final Color lineColor = innerLineColor ?? AppColors.goldDark;
    final Color outerBorderColor = borderColor ?? AppColors.goldDark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardDark,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: outerBorderColor,
          width: 2.5, // ketebalan border luar
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Isi widget
          Positioned.fill(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(12.0),
              child: (leftChild != null || rightChild != null)
                  ? Row(
                      children: [
                        Expanded(child: leftChild ?? const SizedBox()),
                        const SizedBox(width: 8),
                        Expanded(child: rightChild ?? const SizedBox()),
                      ],
                    )
                  : Center(child: centerChild ?? const SizedBox()),
            ),
          ),

          // Garis horizontal tengah (opsional)
          if (showInnerLine)
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: innerLineThickness,
                color: lineColor,
              ),
            ),
        ],
      ),
    );
  }
}
