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
      ),
      child: Column(
        children: [
          _buildMenuItem(LucideIcons.user, "Profil Saya"),
          _divider(),
          _buildMenuItem(LucideIcons.fileText, "Rekam Medis"),
          _divider(),
          _buildMenuItem(LucideIcons.lock, "Ubah Kata Sandi"),
          _divider(),
          _buildMenuItem(LucideIcons.bell, "Notifikasi"),
          _divider(),
          _buildMenuItem(LucideIcons.helpCircle, "Panduan"),
          _divider(),
          _buildMenuItem(LucideIcons.logOut, "Keluar"),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.goldDark),
      title: Text(title, style: AppTextStyles.button),
      onTap: () {},
    );
  }

  Widget _divider() => const Divider(color: AppColors.gold, height: 1);
}
