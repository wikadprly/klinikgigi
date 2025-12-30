import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_button.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_bantuan.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: -160,
              right: -180,
              child: Container(
                width: 550,
                height: 500,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 56, 56),
                  borderRadius: BorderRadius.circular(600),
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              right: -140,
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(600),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: AuthBantuan(
                      onTap: () {
                        debugPrint("Bantuan ditekan");
                      },
                    ),
                  ),

                  const SizedBox(height: 60),

                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo_klinik_kecil.png',
                          height: 150,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "3K DentalCare\nSemarang",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.goldDark,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 110),

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
                    style: TextStyle(
                      color: AppColors.goldDark,
                      fontSize: 16,
                    ),
                  ),

                  const Spacer(),

                  // ✅ FINAL: pakai pushNamed
AuthButton(
  text: "Masuk",
  onPressed: () {
    Navigator.pushNamed(context, '/masuk');
    return Future.value();
  },
),

AuthButton(
  text: "Daftar",
  onPressed: () {
    Navigator.pushNamed(context, '/daftar_pasien_baru');
    return Future.value();
  },
),



                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
