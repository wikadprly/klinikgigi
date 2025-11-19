import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class UbahKataSandi2Page extends StatefulWidget {
  const UbahKataSandi2Page({super.key});

  @override
  State<UbahKataSandi2Page> createState() => _UbahKataSandi2PageState();
}

class _UbahKataSandi2PageState extends State<UbahKataSandi2Page> {
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _onConfirmPressed() async {
    final pass1 = _newPassController.text.trim();
    final pass2 = _confirmPassController.text.trim();

    // VALIDASI
    if (pass1.isEmpty || pass2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom harus diisi")),
      );
      return;
    }

    if (pass1.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kata sandi minimal 6 karakter")),
      );
      return;
    }

    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi kata sandi tidak sesuai")),
      );
      return;
    }

    // SIMULASI PROSES UPDATE
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);

    // SELESAI
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kata sandi berhasil diperbarui")),
    );

    Navigator.pop(context); // kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            children: [
              // HEADER
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

              // JUDUL SECTION
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

              // PASSWORD BARU
              _buildPasswordField(
                controller: _newPassController,
                label: "Kata Sandi Baru",
                obscure: _obscure1,
                onToggle: () => setState(() => _obscure1 = !_obscure1),
              ),

              const SizedBox(height: 24),

              // KONFIRMASI PASSWORD
              _buildPasswordField(
                controller: _confirmPassController,
                label: "Konfirmasi Kata Sandi Baru",
                obscure: _obscure2,
                onToggle: () => setState(() => _obscure2 = !_obscure2),
              ),

              const SizedBox(height: 30),

              // BOX TIPS
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.gold),
                  color: AppColors.white.withOpacity(0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tips bikin Kata Sandi yang aman",
                      style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _tip("1. Hindari huruf/nomor berulang & berurutan, contoh 1234/abcd."),
                    _tip("2. Jangan memakai nama, tanggal lahir, atau nomor HP."),
                    _tip("3. Buat Kata Sandi yang unik."),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // TOMBOL KONFIRMASI
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
                  onPressed: _loading ? null : _onConfirmPressed,
                  child: _loading
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tip(String text) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
        color: AppColors.textMuted,
        fontSize: 12,
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
