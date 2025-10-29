import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_bantuan.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/masuk.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/daftar_pasien_baru.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol bantuan (headset)
              AuthBantuan(
                onTap: () {
                  // Aksi ketika tombol bantuan ditekan
                  debugPrint("Bantuan ditekan");
                },
              ),

              const SizedBox(height: 175),

              // Logo
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/logo_klinik_kecil.png', // Ganti dengan path logo kamu
                  height: 150,
                ),
              ),

              const SizedBox(height: 25),

              // Teks
              const Text(
                "Mulai",
                style: TextStyle(
                  color: AppColors.goldDark,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Mulai dengan Daftar atau Masuk",
                style: TextStyle(color: AppColors.goldDark, fontSize: 16),
              ),

              const Spacer(),

              // Tombol Masuk & Daftar
              AuthButton(
                text: "Masuk",
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              AuthButton(
                text: "Daftar",
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DaftarPasienBaruPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
