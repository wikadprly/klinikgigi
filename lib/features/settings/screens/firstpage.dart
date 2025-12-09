import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:provider/provider.dart';
import 'panduanpage.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_one.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/start.dart';
import 'package:flutter_klinik_gigi/features/profile/screens/profil_screens.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

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
            // ===== DEKORASI LINGKARAN ATAS =====
            Positioned(
              top: -30,
              left: -40,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.10),
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
                  color: AppColors.goldDark.withOpacity(0.06),
                ),
              ),
            ),
            // ==================================

            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // PROFILE HEADER CARD
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

                  // MENU TITLE
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

                  // MENU BOX
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
              _menuItem(Icons.file_copy, "Rekam Medis", () {}),

              _divider(),
              _menuItem(Icons.lock, "Ubah Kata Sandi", () {
                _showConfirmDialog(context, userEmail);
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

// === Dialog Functions Tetap Sama ===

void _showConfirmDialog(BuildContext context, String email) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Konfirmasi Perubahan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Apakah kamu yakin ingin menyimpan perubahan untuk akun $email?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aksi penyimpanan tetap sama, sesuaikan dengan sebelumnya
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Perubahan disimpan.")),
              );
            },
            child: Text("Simpan"),
          ),
        ],
      );
    },
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Keluar Akun",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Apakah kamu yakin ingin logout dari akun ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aksi logout tetap sama, sesuaikan dengan logic kamu
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Berhasil logout.")),
              );
            },
            child: Text("Logout"),
          ),
        ],
      );
    },
  );
}
}
