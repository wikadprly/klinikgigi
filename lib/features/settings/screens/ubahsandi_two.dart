import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/features/settings/providers/reset_password_provider.dart';
import 'package:provider/provider.dart';

class UbahKataSandi2Page extends StatefulWidget {
  final String email; // Ganti dari resetToken menjadi email

  const UbahKataSandi2Page({
    super.key,
    required this.email, // Ganti dari resetToken menjadi email
  });

  @override
  State<UbahKataSandi2Page> createState() => _UbahKataSandi2PageState();
}

class _UbahKataSandi2PageState extends State<UbahKataSandi2Page> {
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  Future<void> _onConfirmPressed(ChangePasswordProvider provider) async {
    final pass1 = _newPassController.text.trim();
    final pass2 = _confirmPassController.text.trim();

    if (pass1.isEmpty || pass2.isEmpty) {
      _show("Semua kolom harus diisi");
      return;
    }

    if (pass1.length < 6) {
      _show("Kata sandi minimal 6 karakter");
      return;
    }

    if (pass1 != pass2) {
      _show("Konfirmasi kata sandi tidak sesuai");
      return;
    }

    if (provider.isLoading) return;

    setState(() => _loading = true);

    try {
      final success = await provider.changePassword(
        newPassword: pass1,
        confirmPassword: pass2,
      );

      if (success) {
        _show("Kata sandi berhasil diperbarui");
        // Kembali ke halaman sebelumnya atau bisa juga kembali ke login
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        _show("Gagal mengganti kata sandi");
      }
    } catch (e) {
      _show("Gagal menghubungi server: ${e.toString()}");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordProvider()..initializeService(),
      child: Consumer<ChangePasswordProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 50,
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
                                color: AppColors.textLight,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Buat Kata Sandi baru",
                      style: AppTextStyles.heading.copyWith(
                        color: AppColors.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Pilih Kata Sandi yang unik dan jangan dibagikan ke siapa pun",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildPasswordField(
                      controller: _newPassController,
                      label: "Kata Sandi Baru",
                      obscure: _obscure1,
                      onToggle: () => setState(() => _obscure1 = !_obscure1),
                    ),

                    const SizedBox(height: 24),

                    _buildPasswordField(
                      controller: _confirmPassController,
                      label: "Konfirmasi Kata Sandi Baru",
                      obscure: _obscure2,
                      onToggle: () => setState(() => _obscure2 = !_obscure2),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: provider.isLoading ? null : () => _onConfirmPressed(provider),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text(
                                "Konfirmasi",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      cursorColor: AppColors.gold,
      style: AppTextStyles.input.copyWith(color: AppColors.textLight),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.label.copyWith(
          color: AppColors.gold,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.gold,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}