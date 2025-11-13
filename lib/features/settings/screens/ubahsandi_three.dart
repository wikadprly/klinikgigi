import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/start.dart'; // pastikan path sesuai

class UbahKataSandiKonfirmasiPage extends StatefulWidget {
  const UbahKataSandiKonfirmasiPage({super.key});

  @override
  State<UbahKataSandiKonfirmasiPage> createState() =>
      _UbahKataSandiKonfirmasiPageState();
}

class _UbahKataSandiKonfirmasiPageState
    extends State<UbahKataSandiKonfirmasiPage> {
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // =========================
  // LOGIKA KONFIRMASI
  // =========================
  Future<void> _onConfirmPressed() async {
    final confirmPassword = _confirmPasswordController.text.trim();

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi konfirmasi tidak boleh kosong')),
      );
      return;
    }

    if (confirmPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi minimal 6 karakter')),
      );
      return;
    }

    // TODO: Integrasikan dengan backend untuk validasi konfirmasi password
    debugPrint('Konfirmasi kata sandi baru: $confirmPassword');

    // Simulasi berhasil ubah sandi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kata sandi berhasil diubah!')),
    );

    // Tunggu sebentar lalu kembali ke halaman login
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER: Back + Judul di Tengah
              // =========================
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
                        'Ubah Kata Sandi',
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

              // =========================
              // SUBTITLE + DESKRIPSI
              // =========================
              Text(
                'Konfirmasi Kata Sandi baru',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ini tahap terakhir, setelah itu selesai!',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // INPUT FIELD
              // =========================
              TextField(
                controller: _confirmPasswordController,
                obscureText: _isObscure,
                cursorColor: AppColors.gold,
                style: AppTextStyles.input.copyWith(color: AppColors.textLight),
                decoration: InputDecoration(
                  hintText: 'Masukkan ulang kata sandi baru',
                  hintStyle:
                      AppTextStyles.label.copyWith(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: AppColors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        BorderSide(color: AppColors.inputBorder, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: AppColors.gold, width: 1.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.gold,
                    ),
                    onPressed: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // =========================
              // TOMBOL KONFIRMASI
              // =========================
              AuthButton(
                text: 'Konfirmasi',
                onPressed: _onConfirmPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
