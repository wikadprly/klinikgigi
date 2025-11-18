import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class ProfileMenuBox extends StatelessWidget {
  const ProfileMenuBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.cardDark,
      ),
      child: Column(
        children: [
          _buildMenuItem(context, LucideIcons.user, "Profil Saya", () {}),
          _divider(),
          _buildMenuItem(context, LucideIcons.fileText, "Rekam Medis", () {}),
          _divider(),
          _buildMenuItem(context, LucideIcons.lock, "Ubah Kata Sandi", () {
            _showConfirmDialog(context);
          }),
          _divider(),
          _buildMenuItem(context, LucideIcons.bell, "Notifikasi", () {}),
          _divider(),
          _buildMenuItem(context, LucideIcons.helpCircle, "Panduan", () {}),
          _divider(),
          _buildMenuItem(context, LucideIcons.logOut, "Keluar", () {
            _showLogoutDialog(context);
          }),
        ],
      ),
    );
  }

  // 🔸 Fungsi untuk membuat item menu
  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.goldDark),
      title: Text(
        title,
        style: AppTextStyles.button.copyWith(color: AppColors.textLight),
      ),
      onTap: onTap,
    );
  }

  // 🔸 Garis pembatas antar menu
  Widget _divider() => const Divider(color: AppColors.gold, height: 1);

  // 🔸 Dialog konfirmasi ubah kata sandi
  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.gold, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Yakin ingin ubah kata sandi?",
                  textAlign: TextAlign.center,
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
                    // Tombol YA
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldDark,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Menu ubah kata sandi diakses."),
                          ),
                        );
                      },
                      child: const Text("Ya"),
                    ),

                    // Tombol TIDAK
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textMuted,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
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

  // 🔸 Dialog konfirmasi keluar aplikasi
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.gold, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Judul dialog
                Text(
                  "Keluar",
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.gold, height: 10, thickness: 0.5),
                const SizedBox(height: 12),

                // 🔹 Isi pesan
                Text(
                  "Apakah anda ingin keluar?",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 22),

                // 🔹 Tombol aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tombol Ya
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldDark,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Berhasil keluar."),
                          ),
                        );
                        // TODO: arahkan ke halaman login
                        // Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text("Ya"),
                    ),

                    // Tombol Tidak
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textMuted,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
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
