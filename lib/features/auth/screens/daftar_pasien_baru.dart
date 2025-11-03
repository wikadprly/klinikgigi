import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_input_field.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';

class DaftarPasienBaruPage extends StatefulWidget {
  const DaftarPasienBaruPage({super.key});

  @override
  State<DaftarPasienBaruPage> createState() => _DaftarPasienBaruPageState();
}

class _DaftarPasienBaruPageState extends State<DaftarPasienBaruPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String tipePasien = 'baru'; // default pasien baru
  String? jenisKelamin;
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

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
                        "Daftar Pasien",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 28,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Dropdown tipe pasien
                DropdownButtonFormField<String>(
                  value: tipePasien,
                  dropdownColor: AppColors.background,
                  decoration: InputDecoration(
                    labelText: "Tipe Pasien",
                    labelStyle: AppTextStyles.label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.goldDark),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'baru', child: Text("Pasien Baru")),
                    DropdownMenuItem(value: 'lama', child: Text("Pasien Lama")),
                  ],
                  onChanged: (val) {
                    setState(() => tipePasien = val!);
                    if (val == 'lama') {
                      Navigator.pushReplacementNamed(
                        context,
                        '/daftar_pasien_lama',
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),

                // 🔹 Input Fields
                AuthInputField(
                  hintText: "Nama Pengguna",
                  controller: namaController,
                ),
                AuthInputField(hintText: "NIK", controller: nikController),
                AuthInputField(hintText: "Email", controller: emailController),
                AuthInputField(hintText: "No. HP", controller: noHpController),

                // 🔹 Tanggal Lahir
                TextField(
                  controller: tanggalLahirController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal Lahir",
                    labelStyle: AppTextStyles.label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.goldDark),
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.goldDark,
                    ),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.goldDark,
                              onPrimary: Colors.white,
                              onSurface: AppColors.background,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      final formatted = DateFormat('yyyy-MM-dd').format(picked);
                      setState(() => tanggalLahirController.text = formatted);
                    }
                  },
                ),
                const SizedBox(height: 15),

                // 🔹 Dropdown Jenis Kelamin
                DropdownButtonFormField<String>(
                  value: jenisKelamin,
                  hint: const Text("Jenis Kelamin"),
                  dropdownColor: AppColors.background,
                  decoration: InputDecoration(
                    labelStyle: AppTextStyles.label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.goldDark),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text("Laki-laki"),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text("Perempuan"),
                    ),
                  ],
                  onChanged: (val) => setState(() => jenisKelamin = val),
                ),
                const SizedBox(height: 15),

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

                // 🔹 Tombol daftar
                AbsorbPointer(
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

                        final success = await authProvider.registerUser(
                          tipePasien: tipePasien,
                          namaPengguna: namaController.text.trim(),
                          nik: nikController.text.trim(),
                          email: emailController.text.trim(),
                          noHp: noHpController.text.trim(),
                          tanggalLahir: tanggalLahirController.text.trim(),
                          jenisKelamin: jenisKelamin ?? '',
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
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Registrasi gagal.")),
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/masuk'),
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
