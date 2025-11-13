import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/settings/widgets/custom_botton_navbar.dart';
import 'package:flutter_klinik_gigi/features/settings/widgets/profile_menu_box.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 🟡 HEADER GRADIENT
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

            // 👤 FOTO PROFIL DAN NAMA
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

            // 📦 MENU BOX
            Positioned(
              top: 300,
              left: 25,
              right: 25,
              child: const ProfileMenuBox(),
            ),
          ],
        ),
      ),

      // 🔻 NAVBAR BAWAH
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
