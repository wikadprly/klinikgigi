import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class UbahKataSandi3Page extends StatefulWidget {
  const UbahKataSandi3Page({super.key});

  @override
  State<UbahKataSandi3Page> createState() => _UbahKataSandi3PageState();
}

class _UbahKataSandi3PageState extends State<UbahKataSandi3Page> {
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi tidak boleh kosong')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi minimal 6 karakter')),
      );
      return;
    }

    // TODO: Tambahkan logika update password ke backend di sini
    debugPrint('Kata sandi baru: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER: Tombol Back + Judul di Tengah
              // =========================
              SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
              // SUBTITLE DAN DESKRIPSI
              // =========================
              Text(
                'Buat Kata Sandi baru',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih Kata Sandi yang unik dan jangan dibagikan ke siapa pun',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // INPUT KATA SANDI BARU
              // =========================
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                cursorColor: AppColors.gold,
                style: AppTextStyles.input.copyWith(color: AppColors.textLight),
                decoration: InputDecoration(
                  hintText: 'Masukkan kata sandi baru',
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
              const SizedBox(height: 28),

              // =========================
              // CARD TIPS KEAMANAN
              // =========================
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.gold, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips bikin Kata Sandi yang aman',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Hindari huruf/nomor berulang & berurutan, contoh 12345/abcde.\n'
                      '2. Jangan menggunakan nama, tanggal lahir, dan nomor HP. Agar sulit untuk ditebak.\n'
                      '3. Buat Kata Sandi yang unik.',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textLight,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // =========================
              // TOMBOL LANJUT
              // =========================
              AuthButton(
                text: 'Lanjut',
                onPressed: _onContinuePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
