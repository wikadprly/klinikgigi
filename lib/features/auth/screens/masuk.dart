import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_input_field.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_input_centang.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 🔹 Tombol Back di pojok atas kiri
            Positioned(
              top: 8,
              left: 12,
              child: BackButtonWidget(
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // 🔹 Isi utama halaman login
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 28),

                    // 🔹 Logo + Judul
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 85, right: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/logo_klinik_kecil.png',
                              height: 160,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Masuk',
                          style: AppTextStyles.heading.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // 🔹 Input No RM/NIK/Email
                    AuthInputField(
                      hintText: 'No RM/NIK/Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 18),

                    // 🔹 Input Kata Sandi
                    AuthInputField(
                      hintText: 'Kata sandi',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 22),

                    // 🔹 Info teks kecil
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          'Akun Gmail anda harus memiliki akses ke rekam medis anda untuk melanjutkan.',
                          style: AppTextStyles.label.copyWith(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Checkbox Custom
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomAgreementCheckbox(
                        label: 'Ingat saya di perangkat ini', // ✅ Tambahkan label
                        onChanged: (val) {
                          setState(() => rememberMe = val);
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 🔹 Tombol Login
                    AuthButton(
                      text: 'Masuk & Lanjutkan',
                      onPressed: () {
                        debugPrint(
                          'Login attempt: ${_emailController.text} / ${_passwordController.text}',
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // 🔹 Teks bawah (daftar)
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                        children: [
                          const TextSpan(text: 'Belum punya akun? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Navigasi ke halaman daftar
                              },
                              child: Text(
                                'Daftar',
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w600,
                                ),
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
          ],
        ),
      ),
    );
  }
}
