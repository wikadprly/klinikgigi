import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ==========================
  // ROW INFORMASI
  // ==========================
  Widget infoRow(IconData icon, String text, {Color? textColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.input.copyWith(
              color: textColor ?? AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================
  // TOMBOL EDIT PROFIL
  // ==========================
  Widget editProfileButton({required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              "Edit Profil",
              style: AppTextStyles.button.copyWith(
                fontSize: 14,
                color: AppColors.background,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =======================================================================
  // POPUP EDIT FOTO – COMPACT
  // =======================================================================
  void showEditPhotoModal(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.45;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
          child: Column(
            children: [
              // CLOSE BUTTON
              Row(
                children: const [
                  Icon(Icons.close, color: AppColors.goldDark, size: 26),
                ],
              ),

              const SizedBox(height: 12),

              // FOTO PROFIL
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),

              const SizedBox(height: 16),

              // GARIS PEMBATAS
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.goldDark,
              ),

              const SizedBox(height: 18),

              // MENU GALERI
              _menuItem(
                icon: Icons.photo,
                text: "Pilih dari galeri",
                onTap: () => Navigator.pop(context),
              ),

              const SizedBox(height: 14),

              // MENU KAMERA
              _menuItem(
                icon: Icons.camera_alt,
                text: "Ambil foto",
                onTap: () => Navigator.pop(context),
              ),

              const SizedBox(height: 14),

              // MENU HAPUS
              _menuItem(
                icon: Icons.delete,
                text: "Hapus",
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // =======================================================================
  // ITEM MENU DALAM POPUP
  // =======================================================================
  Widget _menuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldDark, size: 45),
          const SizedBox(width: 30),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.goldDark,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =======================================================================
  // BUILD UI
  // =======================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // HEADER
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackButtonWidget(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Profil Saya',
                      style: AppTextStyles.heading.copyWith(
                        color: AppColors.goldDark,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // FOTO PROFIL + NAMA + EDIT FOTO
              Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    "Farel Ganteng",
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.goldDark,
                    ),
                  ),

                  const SizedBox(height: 4),

                  GestureDetector(
                    onTap: () => showEditPhotoModal(context),
                    child: Text(
                      "Edit foto",
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.goldDark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // CARD INFORMASI DASAR
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gold, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Dasar",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.gold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 14),

                    infoRow(Icons.phone, "0812-345-6789",
                        textColor: AppColors.goldDark),
                    const SizedBox(height: 14),

                    infoRow(Icons.email, "farelganteng@gmail.com",
                        textColor: AppColors.goldDark),
                    const SizedBox(height: 14),

                    infoRow(Icons.calendar_today, "10 Oktober 2000",
                        textColor: AppColors.goldDark),
                    const SizedBox(height: 14),

                    infoRow(Icons.home, "Jl. Mijen No. 10",
                        textColor: AppColors.goldDark),
                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.center,
                      child: editProfileButton(
                        onTap: () => Navigator.pushNamed(context, "/two_page"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // CARD ASURANSI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Asuransi Saya",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.gold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "Nama Asuransi : BPJS Kesehatan",
                      style:
                          AppTextStyles.input.copyWith(color: AppColors.goldDark),
                    ),
                    Text(
                      "Nomor Peserta : 12345678910",
                      style:
                          AppTextStyles.input.copyWith(color: AppColors.goldDark),
                    ),
                    Text(
                      "Status : Aktif",
                      style:
                          AppTextStyles.input.copyWith(color: AppColors.goldDark),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
