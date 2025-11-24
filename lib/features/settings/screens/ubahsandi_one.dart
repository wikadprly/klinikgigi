import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'ubahsandi_two.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/otp_provider.dart';
import 'package:flutter_klinik_gigi/features/settings/providers/reset_password_provider.dart';

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

  Future<void> _onContinuePressed(
    OtpProvider otpProvider,
    ResetPasswordProvider resetProvider,
  ) async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _show("Kode OTP tidak boleh kosong");
      return;
    }

    if (otp.length < 4) {
      _show("Kode OTP minimal 4 digit");
      return;
    }

    final result = await otpProvider.verifyOtp(widget.email, otp);

    if (result.success && otpProvider.user != null) {
      final resetToken = otpProvider.user!.token; // ambil token dari user
      if (resetToken == null || resetToken.isEmpty) {
        _show("Reset token tidak ditemukan");
        return;
      }

      // simpan token di ResetPasswordProvider
      resetProvider.setResetToken(resetToken);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UbahKataSandi2Page(resetToken: resetToken),
        ),
      );
    } else {
      _show(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
      ],
      child: Consumer2<OtpProvider, ResetPasswordProvider>(
        builder: (context, otpProvider, resetProvider, _) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
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
                        focusedPinTheme: focusedPinTheme,
                        followingPinTheme: followingPinTheme,
                        showCursor: true,
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
                      text: otpProvider.loading ? "Memproses..." : "Lanjut",
                      onPressed: otpProvider.loading
                          ? null
                          : () =>
                                _onContinuePressed(otpProvider, resetProvider),
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
                          GestureDetector(
                            onTap: otpProvider.loading
                                ? null
                                : () async {
                                    final result = await otpProvider.requestOtp(
                                      widget.email,
                                    );
                                    _show(
                                      result.success
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
                        ],
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
