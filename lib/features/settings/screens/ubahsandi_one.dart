import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class UbahKataSandi2Page extends StatefulWidget {
  const UbahKataSandi2Page({super.key});

  @override
  State<UbahKataSandi2Page> createState() => _UbahKataSandi2PageState();
}

class _UbahKataSandi2PageState extends State<UbahKataSandi2Page> {
  final List<TextEditingController> _codeControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    final code = _codeControllers.map((e) => e.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode lengkap terlebih dahulu')),
      );
      return;
    }
    // TODO: tambahkan logika verifikasi ke backend di sini
    debugPrint('Kode yang dimasukkan: $code');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER: Tombol Back di Kiri + Judul di Tengah
              // =========================
              SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Tombol Back di Kiri
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    // Judul di Tengah
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
                'Masukkan Kode e-mail',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan kode untuk mengubah kata sandi ke kata sandi baru',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 32),

              // =========================
              // INPUT KODE OTP (4 DIGIT)
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _codeControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      cursorColor: AppColors.gold,
                      style: AppTextStyles.input.copyWith(
                        fontSize: 22,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.gold.withOpacity(0.6),
                            width: 2,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.gold,
                            width: 2.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: height * 0.08),

              // =========================
              // TOMBOL LANJUT
              // =========================
              AuthButton(
                text: 'Lanjut',
                onPressed: _onContinuePressed,
              ),
              const SizedBox(height: 16),

              // =========================
              // PESAN DI BAWAH
              // =========================
              Center(
                child: Column(
                  children: [
                    Text(
                      'Tidak menerima kode?',
                      style: AppTextStyles.label.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kirim ulang atau gunakan metode verifikasi lain',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
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
