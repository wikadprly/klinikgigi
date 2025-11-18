import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

<<<<<<< HEAD
class AuthButton extends StatelessWidget {
  final String text;
  final Future<void> Function()?
  onPressed; // ✅ ubah dari VoidCallback ke Future<void>
  final Color? textColor;
  final bool isDisabled; // ✅ tambahan: biar tombol bisa dinonaktifkan
=======
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
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
<<<<<<< HEAD
    this.textColor,
=======
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || onPressed == null;

    return GestureDetector(
      onTap: disabled
          ? null
          : () async {
<<<<<<< HEAD
              // ✅ bungkus async di GestureDetector dengan try-catch
              try {
                await onPressed?.call();
              } catch (e) {
                debugPrint('Error in AuthButton: $e');
=======
              try {
                await onPressed?.call();
              } catch (e) {
                debugPrint("AuthButton Error: $e");
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
<<<<<<< HEAD
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
=======
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 12),
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
        decoration: BoxDecoration(
          gradient: disabled
              ? LinearGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.4),
                    AppColors.goldDark.withOpacity(0.4),
                  ],
<<<<<<< HEAD
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [AppColors.gold, AppColors.goldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(8),
=======
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
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
<<<<<<< HEAD
              color: textColor ?? AppColors.background,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
=======
              color: AppColors.background,
              fontWeight: FontWeight.bold,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
            ),
          ),
        ),
      ),
    );
  }
}
