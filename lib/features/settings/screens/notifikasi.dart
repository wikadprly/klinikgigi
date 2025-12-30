import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool janjiTemu = true;
  bool rekamMedis = true;
  bool umum = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Tombol kembali + Judul
              Row(
                children: [
                  BackButtonWidget(onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Text(
                    'Notifikasi',
                    style: AppTextStyles.heading.copyWith(fontSize: 20),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔔 Kategori Janji Temu
              _buildNotificationCard(
                title: 'Notifikasi Janji Temu',
                isActive: janjiTemu,
                onChanged: (value) => setState(() => janjiTemu = value),
                items: const [
                  'Pengingat jadwal pemeriksaan',
                  'Konfirmasi janji temu',
                ],
              ),

              // 🧾 Kategori Rekam Medis
              _buildNotificationCard(
                title: 'Notifikasi Rekam Medis',
                isActive: rekamMedis,
                onChanged: (value) => setState(() => rekamMedis = value),
                items: const ['Hasil pemeriksaan', 'Catatan dokter'],
              ),

              // 📢 Kategori Umum
              _buildNotificationCard(
                title: 'Notifikasi Umum',
                isActive: umum,
                onChanged: (value) => setState(() => umum = value),
                items: const ['Promo & diskon', 'Informasi klinik'],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 Widget builder untuk kartu notifikasi
  Widget _buildNotificationCard({
    required String title,
    required bool isActive,
    required ValueChanged<bool> onChanged,
    required List<String> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold.withOpacity(0.8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul dan switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.button.copyWith(
                  fontSize: 20,
                  color: AppColors.textLight,
                ),
              ),
              Switch(
                value: isActive,
                activeThumbColor: AppColors.background,
                activeTrackColor: AppColors.gold,
                inactiveThumbColor: AppColors.goldDark.withOpacity(0.6),
                inactiveTrackColor: AppColors.gold.withOpacity(0.3),
                onChanged: onChanged,
              ),
            ],
          ),
          const Divider(color: AppColors.gold, thickness: 0.5, height: 12),
          // Isi notifikasi
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: Text(
                item,
                style: AppTextStyles.label.copyWith(
                  fontSize: 17,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
