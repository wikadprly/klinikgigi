import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ penting biar Provider.of() dikenali
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_input_field.dart';
<<<<<<< HEAD
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart'; // 🟡 pastikan path sesuai
=======
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
>>>>>>> main

class DaftarPasienLamaPage extends StatefulWidget {
  const DaftarPasienLamaPage({super.key});

  @override
  State<DaftarPasienLamaPage> createState() => _DaftarPasienLamaPageState();
}

class _DaftarPasienLamaPageState extends State<DaftarPasienLamaPage> {
  final TextEditingController rekamMedisController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool agree = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: true,
    ); // ✅ fix

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                // 🔙 Ganti IconButton lama dengan widget custom kamu
=======
>>>>>>> main
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
                        "Daftar Pasien Lama",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 28,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

<<<<<<< HEAD
                // 🔽 Dropdown Pasien Lama / Baru
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.inputBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: "Pasien Lama",
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: "Pasien Lama",
                            child: Text(
                              "Pasien Lama",
                              style: AppTextStyles.input,
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Pasien Baru",
                            child: Text(
                              "Pasien Baru",
                              style: AppTextStyles.input,
                            ),
                          ),
                        ],
                        onChanged: (_) {},
                        dropdownColor: AppColors.background,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.goldDark,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

=======
                // Input Fields
>>>>>>> main
                AuthInputField(
                  hintText: "Rekam Medis",
                  controller: rekamMedisController,
                ),
                AuthInputField(
                  hintText: "Password",
                  controller: passwordController,
                  obscureText: true,
                ),
                AuthInputField(
                  hintText: "Konfirmasi Password",
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (val) => setState(() => agree = val!),
                      activeColor: AppColors.goldDark,
                    ),
                    Expanded(
                      child: Text(
                        "Setuju dengan Terms & Condition?",
                        style: AppTextStyles.label.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),

<<<<<<< HEAD
                AuthButton(
                  text: "Daftar & Lanjutkan",
                  textColor: AppColors.background,
                  onPressed: () {
                    if (!agree) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Harap setujui Terms & Condition dulu.",
                          ),
                        ),
                      );
                      return;
                    }
                    // TODO: Tambahkan fungsi register API di sini
                  },
=======
                // Tombol daftar
                AbsorbPointer(
                  // ✅ cara aman "disable" GestureDetector tanpa error
                  absorbing: authProvider.isLoading,
                  child: Opacity(
                    opacity: authProvider.isLoading ? 0.6 : 1,
                    child: AuthButton(
                      text: authProvider.isLoading
                          ? "Memproses..."
                          : "Daftar & Lanjutkan",
                      textColor: AppColors.background,
                      onPressed: () async {
                        if (!agree) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Harap setujui Terms & Condition dulu.",
                              ),
                            ),
                          );
                          return;
                        }

                        final success = await authProvider.registerPasienLama(
                          rekamMedis: rekamMedisController.text.trim(),
                          password: passwordController.text.trim(),
                          confirmPassword: confirmPasswordController.text
                              .trim(),
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Registrasi berhasil!"),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Registrasi gagal.")),
                          );
                        }
                      },
                    ),
                  ),
>>>>>>> main
                ),

                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sudah punya akun? Masuk",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.gold,
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
