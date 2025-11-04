import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_input_field.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonWidget(onPressed: () => Navigator.pop(context)),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_klinik_kecil.png',
                        width: 90,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Masuk Akun",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 28,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                AuthInputField(
                  hintText: "Email / NIK / Nomor Rekam Medis",
                  controller: identifierController,
                ),
                const SizedBox(height: 18),
                AuthInputField(
                  hintText: "Kata Sandi",
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (val) =>
                          setState(() => rememberMe = val ?? false),
                      activeColor: AppColors.goldDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Ingat saya di perangkat ini",
                      style: AppTextStyles.label.copyWith(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                AbsorbPointer(
                  absorbing: authProvider.isLoading,
                  child: Opacity(
                    opacity: authProvider.isLoading ? 0.6 : 1,
                    child: AuthButton(
                      text: authProvider.isLoading
                          ? "Memproses..."
                          : "Masuk & Lanjutkan",
                      textColor: AppColors.background,
                      onPressed: () async {
                        final identifier = identifierController.text.trim();
                        final password = passwordController.text.trim();

                        if (identifier.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Mohon isi Email/NIK/RM dan password.",
                              ),
                            ),
                          );
                          return;
                        }

                        final success = await authProvider.login(
                          identifier,
                          password,
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login berhasil!")),
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            '/home_screen',
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Login gagal. Periksa data Anda."),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/daftar_pasien_baru',
                      );
                    },
                    child: Text(
                      "Belum punya akun? Daftar",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.gold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
