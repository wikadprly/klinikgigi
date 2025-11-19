import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'panduanlogin.dart';
import 'panduanhomedental.dart';
import 'panduanreservasi.dart';
import 'panduaneditprofil.dart';
import 'panduanubahsandi.dart';

class PanduanPage extends StatelessWidget {
  const PanduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ============================
              /// HEADER + BACK BUTTON
              /// ============================
              Row(
                children: [
                  BackButtonWidget(
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Panduan Aplikasi",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.goldDark,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ============================
              /// GREETING TEXT
              /// ============================
              Text(
                "Halo, apa ada yang bisa di bantu?",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 24),

              /// ============================
              /// LIST CARD
              /// ============================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.goldDark,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _ListItem(
                      title: "Panduan Login",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PanduanLoginPage(),
                          ),
                        );
                      },
                    ),
                    const _LineSeparator(),

                    _ListItem(
                      title: "Panduan Home Dental Care",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PanduanHomeDentalCarePage(),
                          ),
                        );
                      },
                    ),
                    const _LineSeparator(),

                    _ListItem(
                      title: "Panduan Reservasi",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PanduanReservasiPage(),
                          ),
                        );
                      },
                    ),
                    const _LineSeparator(),

                    _ListItem(
                      title: "Panduan Edit Profil",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PanduanEditProfilScreen(),
                          ),
                        );
                      },
                    ),
                    const _LineSeparator(),

                    _ListItem(
                      title: "Panduan Ubah Sandi",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PanduanUbahSandiScreen(),
                          ),
                        );
                      },
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

/// =======================================
/// ITEM LIST (TEKS + PANAH)
/// =======================================
class _ListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ListItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// TEXT
            Text(
              title,
              style: AppTextStyles.input.copyWith(
                fontSize: 15,
                color: AppColors.textLight,
              ),
            ),

            /// ICON ARROW
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.goldDark,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================
/// PEMISAH GARIS TIPIS EMAS TRANSPARAN
/// =======================================
class _LineSeparator extends StatelessWidget {
  const _LineSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        color: AppColors.goldDark.withOpacity(0.5),
      ),
    );
  }
}
