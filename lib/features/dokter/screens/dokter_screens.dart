import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../core/services/dokter_service.dart';
import '../../../core/models/dokter_model.dart';

// ------------------------------------
// 1. WIDGET KARTU DOKTER MINIMALIS
// ------------------------------------
class MinimalistDokterCard extends StatelessWidget {
  final DokterModel dokter;

  const MinimalistDokterCard({Key? key, required this.dokter})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (dokter.fotoProfil != null &&
        Uri.tryParse(dokter.fotoProfil!)?.hasAbsolutePath == true) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          dokter.fotoProfil!,
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 150,
            color: AppColors.cardDark,
            child: Icon(Icons.person, color: AppColors.textMuted, size: 50),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              height: 150,
              color: AppColors.cardDark,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        ),
      );
    } else {
      imageWidget = Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.person, color: AppColors.gold, size: 60),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.cardDark,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget,
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dokter.namaDokter,
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  dokter.spesialisasi,
                  style: AppTextStyles.label.copyWith(color: AppColors.gold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------
// 2. MAIN SCREEN DOKTER (GRID VIEW)
// ------------------------------------
class DokterScreens extends StatefulWidget {
  const DokterScreens({Key? key}) : super(key: key);

  @override
  State<DokterScreens> createState() => _DokterScreensState();
}

class _DokterScreensState extends State<DokterScreens> {
  late Future<List<DokterModel>> _futureDokter;
  final DokterService _dokterService = DokterService();

  @override
  void initState() {
    super.initState();
    _futureDokter = _dokterService.fetchDokter();
  }

  Future<void> _refreshDokterList() async {
    setState(() {
      _futureDokter = _dokterService.fetchDokter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Dokter Kami',
          style: AppTextStyles.heading.copyWith(color: AppColors.gold),
        ),
        backgroundColor: AppColors.cardDark,
        elevation: 0.5,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDokterList,
        child: FutureBuilder<List<DokterModel>>(
          future: _futureDokter,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Gagal memuat data: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.label.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _refreshDokterList,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                        ),
                        child: Text('Coba Lagi', style: AppTextStyles.button),
                      ),
                    ],
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada data dokter saat ini.',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              );
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MinimalistDokterCard(dokter: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
