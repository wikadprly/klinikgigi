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
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: disabled
              ? LinearGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.4),
                    AppColors.goldDark.withOpacity(0.4),
                  ],
                )
              : const LinearGradient(
                  colors: [
                    AppColors.gold,
                    AppColors.goldDark,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}