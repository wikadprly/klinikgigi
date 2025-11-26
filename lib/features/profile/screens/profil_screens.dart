import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';

class ProfilePage extends StatelessWidget {
  final String token;
  const ProfilePage({super.key, required this.token});

  // ==========================
  // ROW INFORMASI API
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
  // POPUP EDIT FOTO
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
              Row(children: const [Icon(Icons.close, color: AppColors.goldDark, size: 26)]),
              const SizedBox(height: 12),
              const CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/profile.jpg")),
              const SizedBox(height: 16),
              Container(height: 1, width: double.infinity, color: AppColors.goldDark),
              const SizedBox(height: 18),
              _menuItem(icon: Icons.photo, text: "Pilih dari galeri", onTap: () => Navigator.pop(context)),
              const SizedBox(height: 14),
              _menuItem(icon: Icons.camera_alt, text: "Ambil foto", onTap: () => Navigator.pop(context)),
              const SizedBox(height: 14),
              _menuItem(icon: Icons.delete, text: "Hapus", onTap: () => Navigator.pop(context)),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldDark, size: 45),
          const SizedBox(width: 30),
          Text(text, style: const TextStyle(color: AppColors.goldDark, fontSize: 25, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // =======================================================================
  // BUILD UI + API INTEGRATION
  // =======================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder(
          future: Provider.of<ProfilProvider>(context, listen: false).fetchProfil(token),
          builder: (context, snapshot) {
            final provider = Provider.of<ProfilProvider>(context);

            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.gold));
            }

            final user = provider.profilData;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // HEADER
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BackButtonWidget(onPressed: () => Navigator.pop(context)),
                      ),
                      Center(
                        child: Text('Profil Saya', style: AppTextStyles.heading.copyWith(color: AppColors.goldDark)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // FOTO + NAMA API
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user?["file_foto"] != null && user?["file_foto"].isNotEmpty
                            ? NetworkImage(user?["file_foto"]) as ImageProvider
                            : const AssetImage('assets/profile.jpg'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?["nama_pengguna"] ?? "-",
                        style: AppTextStyles.heading.copyWith(color: AppColors.goldDark),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => showEditPhotoModal(context),
                        child: Text("Edit foto", style: AppTextStyles.input.copyWith(color: AppColors.goldDark, fontSize: 14)),
                      )
                    ],
                  ),

                  const SizedBox(height: 25),

                  // CARD INFO DASAR
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
                        Text("Informasi Dasar", style: AppTextStyles.label.copyWith(color: AppColors.gold, fontSize: 18)),
                        const SizedBox(height: 14),

                        infoRow(Icons.person, user?["nama_pengguna"] ?? "-", textColor: AppColors.goldDark),
                        const SizedBox(height: 14),

                        infoRow(Icons.phone, user?["no_hp"] ?? "-", textColor: AppColors.goldDark),
                        const SizedBox(height: 14),

                        infoRow(Icons.email, user?["email"] ?? "-", textColor: AppColors.goldDark),
                        const SizedBox(height: 14),

                        infoRow(Icons.calendar_today, user?["tanggal_lahir"]?.toString() ?? "-", textColor: AppColors.goldDark),
                        const SizedBox(height: 14),

                        infoRow(Icons.location_on, provider.rekamMedisData?["alamat"] ?? "-", textColor: AppColors.goldDark),
                        const SizedBox(height: 14),

                        infoRow(Icons.man, user?["jenis_kelamin"] ?? "-", textColor: AppColors.goldDark),
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.center,
                          child: editProfileButton(onTap: () => Navigator.pushNamed(context, "/two_page")),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // CARD ASURANSI API
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
                        Text("Asuransi Saya", style: AppTextStyles.label.copyWith(color: AppColors.gold, fontSize: 18)),
                        const SizedBox(height: 12),

                        Text("Nama Asuransi : ${provider.namaAsuransi ?? "-"}", style: AppTextStyles.input.copyWith(color: AppColors.goldDark)),
                        Text("Nomor Peserta : ${provider.noPeserta ?? "-"}", style: AppTextStyles.input.copyWith(color: AppColors.goldDark)),
                        Text("Status : ${provider.statusAktif ?? "-"}", style: AppTextStyles.input.copyWith(color: AppColors.goldDark)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}