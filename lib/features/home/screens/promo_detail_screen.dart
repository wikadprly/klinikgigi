import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class PromoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> promo;

  const PromoDetailScreen({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    final String title = promo['judul_promo'] ?? 'Detail Promo';
    final String description = promo['deskripsi'] ?? 'Tidak ada deskripsi';

    String? rawImageUrl = promo['gambar_banner_url'] ?? promo['gambar_banner'];
    if (rawImageUrl != null && !kIsWeb) {
      if (rawImageUrl.contains('localhost')) {
        rawImageUrl = rawImageUrl.replaceAll('localhost', '10.0.2.2');
      } else if (rawImageUrl.contains('127.0.0.1')) {
        rawImageUrl = rawImageUrl.replaceAll('127.0.0.1', '10.0.2.2');
      }
    }
    final String? imageUrl = rawImageUrl;

    final String periode =
        "${promo['tanggal_mulai'] ?? '-'} s/d ${promo['tanggal_selesai'] ?? '-'}";
    final int hargaPoin = promo['harga_poin'] ?? 0;
    // Format numeric point
    final pointString = hargaPoin > 0 ? "$hargaPoin Poin" : "Gratis / 0 Poin";

    // Format nilai potongan if needed, but description might cover it.
    // If we want to show amount:
    // final int nilaiPotongan = int.tryParse(promo['nilai_potongan'].toString()) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background for the app
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Promo",
          style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Background Image (Top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300, // Fixed height for image area
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white24,
                          size: 50,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(Icons.image, color: Colors.white24, size: 50),
                    ),
                  ),
          ),

          // 2. White Card Content (Scrollable)
          Positioned.fill(
            top: 250, // Overlap slightly
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  30,
                  24,
                  30,
                ), // Bottom padding adjusted
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info Row (Periode)
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          periode,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Info Row (Points)
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          size: 18,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Perlu $pointString",
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(color: Colors.white12),
                    ),

                    // Description Label
                    const Text(
                      "Deskripsi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description Body
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
