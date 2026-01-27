import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/dokter_detail_model.dart';
import 'package:flutter_klinik_gigi/core/services/dokter_service.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

// Import Widgets
import '../widgets/dokter_tentang_tab.dart';
import '../widgets/dokter_layanan_tab.dart';

import '../widgets/dokter_sliver_app_bar_delegate.dart';

class DokterDetailScreen extends StatefulWidget {
  final MasterDokterModel dokter;
  const DokterDetailScreen({super.key, required this.dokter});

  @override
  State<DokterDetailScreen> createState() => _DokterDetailScreenState();
}

class _DokterDetailScreenState extends State<DokterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DokterService _dokterService = DokterService();
  late Future<DokterDetailModel> _futureDetailDokter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureDetailDokter = _dokterService.fetchDokterDetail(
      widget.dokter.kodeDokter,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<DokterDetailModel>(
        future: _futureDetailDokter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.background,
                leading: BackButton(color: AppColors.white),
              ),
              backgroundColor: AppColors.background,
              body: Center(
                child: Text(
                  'Gagal memuat detail: ${snapshot.error}',
                  style: AppTextStyles.label.copyWith(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final masterDokter = snapshot.data!;
          final poli = masterDokter.masterPoli?.namaPoli ?? 'N/A';
          final spesialis = masterDokter.spesialisasi ?? 'Dokter Spesialis';

          String fotoUrl = "";
          if (masterDokter.foto != null && masterDokter.foto!.isNotEmpty) {
            fotoUrl = masterDokter.foto!;

            // Fix for Android Emulator (10.0.2.2) vs Web (localhost)
            if (fotoUrl.contains('localhost')) {
              fotoUrl = fotoUrl.replaceAll(
                'localhost',
                'pbl250116.informatikapolines.id',
              );
            } else if (fotoUrl.contains('127.0.0.1')) {
              fotoUrl = fotoUrl.replaceAll(
                '127.0.0.1',
                'pbl250116.informatikapolines.id',
              );
            }
          }

          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 300.0,
                      floating: false,
                      pinned: true,
                      backgroundColor: AppColors.background,
                      leading: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.gold,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: innerBoxIsScrolled
                            ? Text(
                                masterDokter.nama ?? '',
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: 18,
                                  color: AppColors.gold,
                                ),
                              )
                            : null,
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (fotoUrl.isNotEmpty)
                              Image.network(
                                fotoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: AppColors.cardDark),
                              )
                            else
                              Container(
                                color: AppColors.cardDark,
                                child: Icon(
                                  Icons.person,
                                  size: 100,
                                  color: AppColors.gold.withValues(alpha: 0.5),
                                ),
                              ),

                            // Gradient Overlay for text readability
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black87],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              masterDokter.nama ?? 'Nama Dokter',
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.gold.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                spesialis,
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: DokterSliverAppBarDelegate(
                        TabBar(
                          controller: _tabController,
                          labelColor: AppColors.background,
                          unselectedLabelColor: AppColors.textMuted,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.gold,
                          ),
                          dividerColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          tabs: const [
                            Tab(text: 'Tentang'),
                            Tab(text: 'Layanan'),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
            body: TabBarView(
              controller: _tabController,
              children: [
                DokterTentangTab(dokter: masterDokter),
                DokterLayananTab(poli: poli),
              ],
            ),
          );
        },
      ),

      // bottomNavigationBar removed
    );
  }

  // Legacy methods removed
}
