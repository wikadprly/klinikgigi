import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_back.dart';
import '../widgets/auth_input_centang.dart';

class DaftarPasienBaruScreen extends StatefulWidget {
  const DaftarPasienBaruScreen({super.key});

  @override
  State<DaftarPasienBaruScreen> createState() => _DaftarPasienBaruScreenState();
}

class _DaftarPasienBaruScreenState extends State<DaftarPasienBaruScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool agree = false;
  String selectedRole = 'Pasien Baru';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔙 Tombol Back
              Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 16),

              // 🦷 Logo Klinik (bisa diganti sesuai asset kamu)
              Image.asset(
                'assets/images/Logo_klinik.png',
                height: 100,
              ),

              const SizedBox(height: 8),

              // 🏷️ Judul
              const Text(
                "Daftar",
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // 🔽 Dropdown: Pasien Baru
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.goldDark, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    iconEnabledColor: AppColors.goldDark,
                    dropdownColor: AppColors.background,
                    style: const TextStyle(color: AppColors.textLight, fontSize: 16),
                    items: const [
                      DropdownMenuItem(
                        value: 'Pasien Baru',
                        child: Text('Pasien Baru'),
                      ),
                      DropdownMenuItem(
                        value: 'Pasien Lama',
                        child: Text('Pasien Lama'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedRole = value!);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 🧾 Input Fields
              AuthInputField(controller: namaController, hintText: "Nama Pengguna"),
              const SizedBox(height: 12),
              AuthInputField(controller: nikController, hintText: "NIK"),
              const SizedBox(height: 12),
              AuthInputField(controller: tanggalLahirController, hintText: "Tanggal Lahir"),
              const SizedBox(height: 12),
              AuthInputField(controller: jenisKelaminController, hintText: "Jenis Kelamin"),
              const SizedBox(height: 12),
              AuthInputField(controller: kontakController, hintText: "No.HP/Email"),
              const SizedBox(height: 12),
              AuthInputField(controller: passwordController, hintText: "Password", isPassword: true),
              const SizedBox(height: 12),
              AuthInputField(controller: confirmPasswordController, hintText: "Konfirmasi Password", isPassword: true),

              const SizedBox(height: 16),

              // 🟨 Checkbox “Setuju dan Lanjutkan”
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Setuju Dengan Terms & Condition?",
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CustomAgreementCheckbox(
                      label: "Setuju dan lanjutkan",
                      onChanged: (value) {
                        setState(() => agree = value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 🟡 Tombol Daftar & Lanjutkan
              AuthButton(
                text: "Daftar & Lanjutkan",
                onPressed: agree
                    ? () {
                        debugPrint("Mendaftar sebagai $selectedRole...");
                      }
                    : null, // disable kalau belum centang
              ),

              const SizedBox(height: 24),

              // 🔵 Link Masuk
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah punya akun? ",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      // pindah ke halaman login
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
