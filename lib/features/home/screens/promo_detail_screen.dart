import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class PromoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> promo;

  const PromoDetailScreen({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    final String title = promo['judul_promo'] ?? 'Detail Promo';
    final String description = promo['deskripsi'] ?? 'Tidak ada deskripsi';
    final String? imageUrl = promo['gambar_banner'];
    final String periode =
        "${promo['tanggal_mulai'] ?? '-'} s/d ${promo['tanggal_selesai'] ?? '-'}";
    final int hargaPoin = promo['harga_poin'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Detail Promo", style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            if (imageUrl != null && imageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[800],
                child: const Icon(Icons.image, color: Colors.white, size: 80),
              ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    title,
                    style: AppTextStyles.heading.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 12),

                  // Info Tambahan (Periode & Poin)
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: AppColors.textMuted,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        periode,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (hargaPoin > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: AppColors.gold,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Perlu $hargaPoin Poin",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                  const Divider(color: Colors.white24, height: 32),

                  // Deskripsi
                  Text(
                    "Deskripsi",
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.input.copyWith(
                      height: 1.6,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar removed to eliminate redundant back button
    );
  }
}
