import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/features/settings/providers/reset_password_provider.dart';
import 'ubahsandi_two.dart';

class UbahKataSandi1Page extends StatefulWidget {
  final String email;

  const UbahKataSandi1Page({super.key, required this.email});

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

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _onContinuePressed(ChangePasswordProvider provider) async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _show("Kode OTP tidak boleh kosong");
      return;
    }

    if (otp.length != 6) {
      _show("Kode OTP harus 6 digit");
      return;
    }

    if (provider.isLoading) return;

    try {
      final success = await provider.verifyOtp(otp);

      if (!success) {
        _show("OTP salah atau kadaluarsa");
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UbahKataSandi2Page(email: widget.email),
        ),
      );
    } catch (e) {
      _show("Terjadi kesalahan saat verifikasi OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordProvider()..initializeService(),
      child: Consumer<ChangePasswordProvider>(
        builder: (context, provider, _) {
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
                bottom: BorderSide(color: AppColors.gold, width: 2),
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
                      "Masukkan Kode OTP",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Masukkan kode yang dikirim ke email kamu",
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
                        focusedPinTheme: defaultPinTheme,
                        followingPinTheme: defaultPinTheme,
                        showCursor: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    const SizedBox(height: 40),

                    AuthButton(
                      text: provider.isLoading ? "Memproses..." : "Lanjut",
                      onPressed: provider.isLoading
                          ? null
                          : () => _onContinuePressed(provider),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                final success = await provider.requestOtp();

                                _show(
                                  success
                                      ? "Kode OTP telah dikirim ulang"
                                      : "Gagal mengirim ulang kode",
                                );
                              },
                        child: Text(
                          "Kirim ulang",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
