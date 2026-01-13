import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/config/api.dart'; // Import baseUrl
import '../screens/dokter_detail_screens.dart';

class DokterListCard extends StatelessWidget {
  final MasterDokterModel dokter;

  const DokterListCard({super.key, required this.dokter});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (dokter.foto != null && dokter.foto!.isNotEmpty) {
      // PROXY ROUTE: Use /api/dokter-image/{filename} to fix CORS on Web
      String filename = dokter.foto!.split('/').last;
      String imageUrl = "$baseUrl/dokter-image/$filename";

      if (!kIsWeb) {
        if (imageUrl.contains('localhost')) {
          imageUrl = imageUrl.replaceAll(
            'localhost',
            'pbl250116.informatikapolines.id',
          );
        } else if (imageUrl.contains('127.0.0.1')) {
          imageUrl = imageUrl.replaceAll(
            '127.0.0.1',
            'pbl250116.informatikapolines.id',
          );
        }
      }

      imageWidget = CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: AppColors.cardDark,
        onBackgroundImageError: (_, __) {
          // Fallback is handled by the initial state effectively if we had a stateful widget,
          // but since it's stateless, we can't easily swap to initials on error *after* build.
          // However, CircleAvatar keeps the background color/placeholder if image fails.
        },
      );
    } else if (dokter.inisial.isNotEmpty) {
      // Use Initials if no photo
      imageWidget = CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.gold.withOpacity(0.2),
        child: Text(
          dokter.inisial,
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    } else {
      imageWidget = CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.gold.withOpacity(0.2),
        child: const Icon(Icons.person, color: AppColors.gold, size: 30),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DokterDetailScreen(dokter: dokter),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                imageWidget,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dokter.nama,
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dokter.poliNama != null && dokter.poliNama!.isNotEmpty
                              ? dokter.poliNama!
                              : "Dokter Umum",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textMuted.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
