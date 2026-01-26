import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/otp_provider.dart';

class OtpScreen extends StatefulWidget {
  final String? email;

  const OtpScreen({super.key, this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp(String email) async {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit kode verifikasi.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final otpProvider = context.read<OtpProvider>();

      final success = await otpProvider.verifyOtp(email, otp);

      if (success.success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kode berhasil diverifikasi!')));

        Navigator.pushReplacementNamed(
          context,
          '/main_screen',
          arguments: otpProvider.user,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verifikasi gagal: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Gunakan email dari parameter widget
    final email = widget.email ?? "-";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 60),

              Text(
                'Masukan kode verifikasi',
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.gold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'Kode verifikasi telah dikirim ke\n$email',
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: (width - 48 - 50) / 6,
                    child: TextField(
                      controller: _otpControllers[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: "", // Hilangkan hitungan "0/1"
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.goldDark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.gold,
                            width: 2.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              AuthButton(
                text: _isLoading ? 'Memverifikasi...' : 'Lanjutkan',
                onPressed: _isLoading ? null : () => _verifyOtp(email),
                isDisabled: _isLoading,
              ),

              const SizedBox(height: 24),

              Text(
                'Tidak menerima kode?',
                style: AppTextStyles.label.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: 6),

              GestureDetector(
                onTap: () async {
                  try {
                    final otpProvider = context.read<OtpProvider>();
                    await otpProvider.requestOtp(email);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Kode OTP telah dikirim ulang."),
                      ),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Gagal mengirim ulang kode."),
                      ),
                    );
                  }
                },
                child: Text(
                  'Kirim ulang kode OTP',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
