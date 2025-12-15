import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:provider/provider.dart';

import 'panduanpage.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_one.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';
import 'package:flutter_klinik_gigi/features/profile/screens/profil_screens.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/start.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userEmail = authProvider.user?.email ?? '';
    final userName = authProvider.user?.namaPengguna ?? 'Pengguna';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ----- Dekorasi Lingkaran Atas -----
            Positioned(
              top: -30,
              left: -40,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.20),
                ),
              ),
            ),
            Positioned(
              top: -70,
              right: -20,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldDark.withOpacity(0.10),
                ),
              ),
            ),

            // ===== Konten Body =====
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // ===== Profil Header =====
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gold, width: 3),
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 55,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userName,
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 22,
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ===== Judul Pengaturan =====
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pengaturan",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.gold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== Menu Box =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: _menuBox(context, userEmail),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuBox(BuildContext context, String userEmail) {
    return FutureBuilder<String?>(
      future: SharedPrefsHelper.getToken(),
      builder: (context, snapshot) {
        final token = snapshot.data ?? '';

        return Container(
          padding: const EdgeInsets.only(bottom: 5), // ⬅⬅ BOX DIPERBESAR
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gold),
            borderRadius: BorderRadius.circular(14),
            color: AppColors.cardDark,
          ),
          child: Column(
            children: [
              _menuItem(Icons.person, "Profil Saya", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(token: token),
                  ),
                );
              }),

              _divider(),

              // ——— REKAM MEDIS DIHAPUS TOTAL ———

              _menuItem(Icons.lock, "Ubah Kata Sandi", () {
                _confirmChangePassword(context, userEmail);
              }),

              _divider(),

              _menuItem(Icons.help, "Panduan", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PanduanPage()),
                );
              }),

              _divider(),

              _menuItem(Icons.logout, "Keluar", () {
                _showLogoutDialog(context);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.goldDark, size: 26),
      title: Text(
        title,
        style: AppTextStyles.button.copyWith(color: AppColors.textLight),
      ),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(color: AppColors.gold, height: 1);

  // ====== POPUP UBAH SANDI ======
  void _confirmChangePassword(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.gold, width: 1),
          ),
          title: Text(
            "Ubah Kata Sandi",
            style: AppTextStyles.heading.copyWith(
              color: AppColors.gold,
            ),
          ),
          content: Text(
            "Apakah kamu yakin ingin mengubah kata sandi?",
            style: AppTextStyles.button.copyWith(
              color: AppColors.textLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Batal",
                style: TextStyle(color: AppColors.goldDark),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UbahKataSandi1Page(email: email),
                  ),
                );
              },
              child: const Text("Lanjut"),
            ),
          ],
        );
      },
    );
  }

  // ====== POPUP LOGOUT ======
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.gold, width: 1),
          ),
          title: Text(
            "Keluar Akun",
            style: AppTextStyles.heading.copyWith(
              color: AppColors.gold,
            ),
          ),
          content: Text(
            "Apakah kamu yakin ingin logout dari akun ini?",
            style: AppTextStyles.button.copyWith(
              color: AppColors.textLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Batal",
                style: TextStyle(color: AppColors.goldDark),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                Navigator.pop(context);

                await SharedPrefsHelper.clearToken();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const StartScreen()),
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
