import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // == REUSABLE ROW INFORMASI ==
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

  // == TOMBOL EDIT PROFIL ==
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
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // ---------- HEADER ----------
             Stack(
              alignment: Alignment.center,
              children: [
               Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(
                 onPressed: () {
                   Navigator.pop(context);
          },
      ),
    ),
    Center(
      child: Text(
        'Profil Saya',
        style: AppTextStyles.heading.copyWith(color: AppColors.goldDark),
      ),
    ),
  ],
),


              const SizedBox(height: 25),

              // ---------- FOTO PROFIL ----------
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[700],
                    backgroundImage: const AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 12),
                  Text("Farel Ganteng", style: AppTextStyles.heading.copyWith(color: AppColors.goldDark)),
                ],
              ),

              const SizedBox(height: 25),

              // ---------- CARD INFORMASI DASAR ----------
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
                    Text("Informasi Dasar", style: AppTextStyles.label.copyWith(color: AppColors.gold,fontSize: 18,)),
                    const SizedBox(height: 14),

                    infoRow(Icons.phone, "0812-345-6789", textColor: AppColors.goldDark),
                    const SizedBox(height: 14),   

                    infoRow(Icons.email, "farelganteng@gmail.com", textColor: AppColors.goldDark),
                    const SizedBox(height: 14),

                    infoRow(Icons.calendar_today, "10 Oktober 2000", textColor: AppColors.goldDark),
                    const SizedBox(height: 14),

                    infoRow(Icons.home, "Jl. Mijen No. 10", textColor: AppColors.goldDark),
                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.center,
                      child: editProfileButton(
                        onTap: () {
                          Navigator.pushNamed(context, "/edit-profile");
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ---------- CARD ASURANSI ----------
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
                    Text("Asuransi Saya", style: AppTextStyles.label.copyWith(color: AppColors.gold,fontSize: 18)),
                    const SizedBox(height: 12),

                    Text("Nama Asuransi : BPJS Kesehatan", style: AppTextStyles.input.copyWith(color: AppColors.goldDark)),
                    Text("Nomor Peserta : 12345678910", style: AppTextStyles.input.copyWith(color: AppColors.goldDark)),
                    Text("Status : Aktif", style: AppTextStyles.input.copyWith(color: AppColors.goldDark)),
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
