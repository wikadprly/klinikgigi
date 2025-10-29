import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

// ✅ Import widgets yang sudah kamu pisahkan
import 'package:flutter_klinik_gigi/features/profile/widgets/password_input_field.dart';
import 'package:flutter_klinik_gigi/features/profile/widgets/tips_box.dart';
import 'package:flutter_klinik_gigi/features/profile/widgets/custom_button.dart';

class MasukKataSandiPage extends StatefulWidget {
  const MasukKataSandiPage({super.key});

  @override
  State<MasukKataSandiPage> createState() => _MasukKataSandiPageState();
}

class _MasukKataSandiPageState extends State<MasukKataSandiPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ubah Kata Sandi",
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Masukkan Kata Sandi",
              style: AppTextStyles.heading.copyWith(color: AppColors.gold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Masukkan kata sandi lama untuk mengubah ke kata sandi baru",
              style: AppTextStyles.label,
            ),
            const SizedBox(height: 16),

            // ✅ pakai widget terpisah
            PasswordInputField(
              controller: _passwordController,
              hintText: "Masukkan kata sandi lama",
            ),

            const SizedBox(height: 20),

            // ✅ Tips Box widget
            const TipsBox(),

            const SizedBox(height: 30),

            // ✅ Custom Button widget
            CustomButton(
              text: "Lanjut",
              onPressed: () {
                // TODO: aksi lanjut
              },
            ),
          ],
        ),
      ),
    );
  }
}
