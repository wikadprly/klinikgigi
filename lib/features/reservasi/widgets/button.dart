import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class ButtonText {
  static const String cekJadwal = "Cek Jadwal";
  static const String bayar = "Bayar";
  static const String selesai = "Selesai";
  static const String simpanKodeQR = "Simpan Kode QR";
  static const String kembaliKeBeranda = "Kembali ke Beranda";
  static const String lihatRiwayat = "Lihat Riwayat";
}

class AuthButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final bool isDisabled;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || onPressed == null;

    return GestureDetector(
      onTap: disabled
          ? null
          : () async {
              try {
                await onPressed?.call();
              } catch (e) {
                debugPrint("AuthButton Error: $e");
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(vertical: 12),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),

          // ✨ Border Warm
          border: Border.all(
            color: disabled
                ? AppColors.cardWarm.withOpacity(0.4)
                : AppColors.cardWarm,
            width: 1.2,
          ),

          // ✨ Gradient Gold (but softer)
          gradient: disabled
              ? LinearGradient(
                  colors: [
                    AppColors.goldDark.withOpacity(0.3),
                    AppColors.gold.withOpacity(0.3),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : const LinearGradient(
                  colors: [
                    AppColors.goldDark,
                    AppColors.gold,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),

          // ✨ Premium soft shadow
          boxShadow: disabled
              ? []
              : [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: AppColors.background, // biar kontras & elegant
              fontWeight: FontWeight.w700,
              fontSize: 17,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
