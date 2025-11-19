import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:pinput/pinput.dart';
import 'ubahsandi_two.dart';

class UbahKataSandi1Page extends StatefulWidget {
  const UbahKataSandi1Page({super.key});

  @override
  State<UbahKataSandi1Page> createState() => _UbahKataSandi1PageState();
}

class _UbahKataSandi1PageState extends State<UbahKataSandi1Page> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP tidak boleh kosong")),
      );
      return;
    }

    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP minimal 4 digit")),
      );
      return;
    }

    debugPrint("OTP dimasukkan: $otp");

    await Future.delayed(const Duration(milliseconds: 200));

    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const UbahKataSandi2Page()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 42,
      height: 55,
      textStyle: AppTextStyles.heading.copyWith(
        color: AppColors.textLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.gold,
            width: 2,
          ),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: const Border(
        bottom: BorderSide(color: AppColors.gold, width: 2.5),
      ),
    );

    final followingPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border(
        bottom: BorderSide(
          color: AppColors.gold.withOpacity(0.4),
          width: 1.5,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Ubah Kata Sandi",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 20,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Text(
                "Masukkan Kode e-mail",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Masukkan kode untuk mengubah kata sandi ke kata sandi baru",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textLight,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Pinput(
                  length: 6,
                  controller: _otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  followingPinTheme: followingPinTheme,
                  showCursor: true,
                  // cursor widget sebagai pengganti cursorColor / cursorEnabled
                  cursor: Container(
                    width: 2,
                    height: 22,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(height: 40),

              AuthButton(
                text: "Lanjut",
                onPressed: _onContinuePressed,
              ),

              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    Text(
                      "Tidak menerima kode?",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Kirim ulang atau gunakan metode verifikasi lain",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
