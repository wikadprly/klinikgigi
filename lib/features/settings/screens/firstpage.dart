import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:provider/provider.dart';
import 'notifikasi.dart';
import 'panduanpage.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_one.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';
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
            // FIXED HEADER (tidak menutupi menu lagi)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            ),

            // FOTO DAN NAMA
            Positioned(
              top: 95,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.gold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // MENU BOX (TIDAK TERTUTUP HEADER)
            Positioned(
              top: 300,
              left: 25,
              right: 25,
              child: _menuBox(context, userEmail),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuBox(BuildContext context, String userEmail) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.cardDark,
      ),
      child: Column(
        children: [
          _menuItem(Icons.person, "Profil Saya", () {}),
          _divider(),
          _menuItem(Icons.file_copy, "Rekam Medis", () {}),
          _divider(),

          // UBAH KATA SANDI — POPUP FIXED
          _menuItem(Icons.lock, "Ubah Kata Sandi", () {
            _showConfirmDialog(context, userEmail);
          }),

          _divider(),
          _menuItem(Icons.notifications, "Notifikasi", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationSettingsPage()),
            );
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
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.goldDark),
      title: Text(
        title,
        style: AppTextStyles.button.copyWith(color: AppColors.textLight),
      ),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(color: AppColors.gold, height: 1);

  // ============================
  // POPUP UBAH KATA SANDI (FIX)
  // ============================
  void _showConfirmDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.gold),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Yakin ingin ubah kata sandi?",
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldDark,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UbahKataSandi1Page(email: email),
                          ),
                        );
                      },
                      child: const Text("Ya"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textMuted,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text("Tidak"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 // ============================
// POPUP LOGOUT (SUDAH DIBENERIN)
// ============================
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.gold),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Keluar",
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Apakah anda ingin keluar?",
                style: AppTextStyles.label.copyWith(color: AppColors.textLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldDark,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);

                      // ARAHKAN KE STARTSCREEN & HAPUS HISTORY
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const StartScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text("Ya"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textMuted,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("Tidak"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
}