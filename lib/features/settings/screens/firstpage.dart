import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:provider/provider.dart';
import 'notifikasi.dart';
import 'panduanpage.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_one.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<AuthProvider>(context).user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // HEADER
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(400),
                    bottomRight: Radius.circular(400),
                  ),
                ),
              ),
            ),

            // FOTO + NAMA
            Positioned(
              top: 90,
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
                    'Farel Ganteng',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.gold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // MENU
            Positioned(top: 300, left: 25, right: 25, child: _menuBox(context)),
          ],
        ),
      ),
    );
  }

  // ==============================
  // MENU BOX
  // ==============================
  Widget _menuBox(BuildContext context) {
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
          _menuItem(Icons.lock, "Ubah Kata Sandi", () {
            _showConfirmDialog(context);
          }),
          _divider(),
          _menuItem(Icons.notifications, "Notifikasi", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationSettingsPage(),
              ),
            );
          }),
          _divider(),

          // === PANDUAN FIX ===
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

  // ==================================================
  // DIALOG UBAH KATA SANDI  (INI HILANG DI KODEMU)
  // ==================================================
  void _showConfirmDialog(BuildContext context) {
    final userEmail = Provider.of<AuthProvider>(context).user?.email ?? '';
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
                            builder: (_) =>
                                UbahKataSandi1Page(email: userEmail),
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

  // ==================================================
  // DIALOG LOGOUT  (INI JUGA HILANG DI KODEMU)
  // ==================================================
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
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                  ),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil keluar.")),
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
