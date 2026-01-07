import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../core/services/dokter_service.dart';
import '../../../core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/features/dokter/widgets/dokter_list_card.dart';
import 'dart:async';

// ------------------------------------
// 1. WIDGET KARTU DOKTER BARU (SESUAI DESAIN 1.png)
// ------------------------------------
// _DokterListCard widget moved to widgets/dokter_list_card.dart

// ------------------------------------
// 2. MAIN SCREEN DOKTER
// ------------------------------------
class DokterScreens extends StatefulWidget {
  const DokterScreens({super.key});

  @override
  State<DokterScreens> createState() => _DokterScreensState();
}

class _DokterScreensState extends State<DokterScreens> {
  late Future<List<MasterDokterModel>> _futureDokter;
  final DokterService _dokterService = DokterService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // State for filter
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _futureDokter = _dokterService.fetchDokter();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchData(String? query) {
    setState(() {
      _futureDokter = _dokterService.fetchDokter(query);
      // Reset filter when searching, optional but usually good UX
      if (query != null && query.isNotEmpty) {
        _selectedCategory = 'Semua';
      }
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchData(_searchController.text.trim());
    });
  }

  Future<void> _refreshDokterList() async {
    _searchController.clear();
    setState(() {
      _selectedCategory = 'Semua';
    });
    _fetchData(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Daftar Dokter',
          style: AppTextStyles.heading.copyWith(color: AppColors.gold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // --- Modern Search Bar ---
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.textMuted.withOpacity(0.2)),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.input,
                decoration: InputDecoration(
                  hintText: 'Cari dokter spesialis...',
                  hintStyle: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted.withOpacity(0.5),
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.gold),
                  filled: true,
                  fillColor: Colors
                      .transparent, // Transparan karena container sudah berwarna
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshDokterList,
                color: AppColors.gold,
                child: FutureBuilder<List<MasterDokterModel>>(
                  future: _futureDokter,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Terjadi Kesalahan',
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${'${snapshot.error}'.substring(0, 50)}...", // Truncate error
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _refreshDokterList,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'Coba Lagi',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              color: AppColors.textMuted.withOpacity(0.5),
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Dokter tidak ditemukan',
                              style: AppTextStyles.label.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final allDokters = snapshot.data!;

                      // 1. Extract Unique Categories (Spesialisasi)
                      // Filter out empty strings if any, or map them to 'Umum'
                      final Set<String> categoriesSet = {};
                      for (var d in allDokters) {
                        if (d.spesialisasi.isNotEmpty) {
                          categoriesSet.add(d.spesialisasi);
                        }
                      }
                      final categories = [
                        'Semua',
                        ...categoriesSet.toList()..sort(),
                      ];

                      // 2. Filter List
                      final filteredDokters = _selectedCategory == 'Semua'
                          ? allDokters
                          : allDokters
                                .where(
                                  (d) => d.spesialisasi == _selectedCategory,
                                )
                                .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Filter Chips ---
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: categories.map((category) {
                                final isSelected =
                                    _selectedCategory == category;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                    label: Text(category),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    },
                                    backgroundColor: AppColors.cardDark,
                                    selectedColor: AppColors.gold,
                                    checkmarkColor: AppColors.background,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? AppColors.background
                                          : AppColors.textMuted,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Colors.transparent
                                            : AppColors.textMuted.withOpacity(
                                                0.2,
                                              ),
                                      ),
                                    ),
                                    showCheckmark: false,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // --- Doctor List ---
                          Expanded(
                            child: filteredDokters.isEmpty
                                ? Center(
                                    child: Text(
                                      'Tidak ada dokter di kategori ini',
                                      style: AppTextStyles.label.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    itemCount: filteredDokters.length,
                                    itemBuilder: (context, index) {
                                      final dokter = filteredDokters[index];
                                      return DokterListCard(dokter: dokter);
                                    },
                                  ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
